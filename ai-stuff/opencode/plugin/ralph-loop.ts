import type { Plugin } from "@opencode-ai/plugin"
import { existsSync, readFileSync, writeFileSync, unlinkSync, mkdirSync } from "node:fs"
import { dirname, join } from "node:path"

const STATE_FILE = ".opencode/ralph-loop.local.md"
const DEFAULT_MAX_ITERATIONS = 100

interface RalphLoopState {
  active: boolean
  iteration: number
  max_iterations: number
  completion_promise: string
  started_at: string
  prompt: string
  session_id?: string
}

function getStateFilePath(directory: string): string {
  return join(directory, STATE_FILE)
}

function parseFrontmatter(content: string): { data: Record<string, string>; body: string } {
  const match = content.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/)
  if (!match) return { data: {}, body: content }

  const frontmatter = match[1]
  const body = match[2]
  const data: Record<string, string> = {}

  for (const line of frontmatter.split("\n")) {
    const colonIndex = line.indexOf(":")
    if (colonIndex === -1) continue
    const key = line.slice(0, colonIndex).trim()
    let value = line.slice(colonIndex + 1).trim()
    value = value.replace(/^["']|["']$/g, "")
    data[key] = value
  }

  return { data, body }
}

function readState(directory: string): RalphLoopState | null {
  const filePath = getStateFilePath(directory)
  if (!existsSync(filePath)) return null

  try {
    const content = readFileSync(filePath, "utf-8")
    const { data, body } = parseFrontmatter(content)

    if (data.active === undefined || data.iteration === undefined) return null

    const isActive = data.active === "true"
    const iteration = parseInt(data.iteration, 10)
    if (isNaN(iteration)) return null

    return {
      active: isActive,
      iteration,
      max_iterations: parseInt(data.max_iterations, 10) || DEFAULT_MAX_ITERATIONS,
      completion_promise: data.completion_promise || "DONE",
      started_at: data.started_at || new Date().toISOString(),
      prompt: body.trim(),
      session_id: data.session_id || undefined,
    }
  } catch {
    return null
  }
}

function writeState(directory: string, state: RalphLoopState): boolean {
  const filePath = getStateFilePath(directory)

  try {
    const dir = dirname(filePath)
    if (!existsSync(dir)) {
      mkdirSync(dir, { recursive: true })
    }

    const sessionIdLine = state.session_id ? `session_id: "${state.session_id}"\n` : ""
    const content = `---
active: ${state.active}
iteration: ${state.iteration}
max_iterations: ${state.max_iterations}
completion_promise: "${state.completion_promise}"
started_at: "${state.started_at}"
${sessionIdLine}---
${state.prompt}
`

    writeFileSync(filePath, content, "utf-8")
    return true
  } catch {
    return false
  }
}

function clearState(directory: string): boolean {
  const filePath = getStateFilePath(directory)
  try {
    if (existsSync(filePath)) {
      unlinkSync(filePath)
    }
    return true
  } catch {
    return false
  }
}

function escapeRegex(str: string): string {
  return str.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")
}

function detectCompletionPromise(text: string, promise: string): boolean {
  const pattern = new RegExp(`<promise>\\s*${escapeRegex(promise)}\\s*</promise>`, "is")
  return pattern.test(text)
}

const CONTINUATION_PROMPT = `[RALPH LOOP - ITERATION {{ITERATION}}/{{MAX}}]

Your previous attempt did not output the completion promise. Continue working on the task.

IMPORTANT:
- Review your progress so far
- Continue from where you left off
- When FULLY complete, output: <promise>{{PROMISE}}</promise>
- Do not stop until the task is truly done

Original task:
{{PROMPT}}`

export const RalphLoopPlugin: Plugin = async ({ client, directory }) => {
  return {
    event: async ({ event }) => {
      const props = event.properties as Record<string, unknown> | undefined

      if (event.type === "session.idle") {
        const sessionID = props?.sessionID as string | undefined
        if (!sessionID) return

        const state = readState(directory)
        if (!state || !state.active) return

        if (state.session_id && state.session_id !== sessionID) return

        // Update session_id on first idle if not set
        if (!state.session_id) {
          state.session_id = sessionID
          writeState(directory, state)
        }

        // Get last assistant message to check for completion
        try {
          const response = await client.session.messages({
            path: { id: sessionID },
            query: { directory },
          })

          const messages = (response as { data?: unknown[] }).data ?? []
          if (Array.isArray(messages)) {
            type MessageInfo = { role?: string }
            type MessagePart = { type: string; text?: string }
            type SessionMessage = { info?: MessageInfo; parts?: MessagePart[] }

            const assistantMessages = (messages as SessionMessage[]).filter(
              (msg) => msg.info?.role === "assistant"
            )
            const lastAssistant = assistantMessages[assistantMessages.length - 1]

            if (lastAssistant?.parts) {
              const responseText = lastAssistant.parts
                .filter((p) => p.type === "text")
                .map((p) => p.text ?? "")
                .join("\n")

              if (detectCompletionPromise(responseText, state.completion_promise)) {
                clearState(directory)
                await client.tui.showToast({
                  body: {
                    title: "Ralph Loop Complete!",
                    message: `Task completed after ${state.iteration} iteration(s)`,
                    variant: "success",
                    duration: 5000,
                  },
                })
                return
              }
            }
          }
        } catch {
          // Continue with loop if API call fails
        }

        // Check max iterations
        if (state.iteration >= state.max_iterations) {
          clearState(directory)
          await client.tui.showToast({
            body: {
              title: "Ralph Loop Stopped",
              message: `Max iterations (${state.max_iterations}) reached without completion`,
              variant: "warning",
              duration: 5000,
            },
          })
          return
        }

        // Increment iteration and continue
        state.iteration += 1
        if (!writeState(directory, state)) return

        const continuationPrompt = CONTINUATION_PROMPT
          .replace("{{ITERATION}}", String(state.iteration))
          .replace("{{MAX}}", String(state.max_iterations))
          .replace("{{PROMISE}}", state.completion_promise)
          .replace("{{PROMPT}}", state.prompt)

        await client.tui.showToast({
          body: {
            title: "Ralph Loop",
            message: `Iteration ${state.iteration}/${state.max_iterations}`,
            variant: "info",
            duration: 2000,
          },
        })

        try {
          await client.session.prompt({
            path: { id: sessionID },
            body: {
              parts: [{ type: "text", text: continuationPrompt }],
            },
            query: { directory },
          })
        } catch {
          // Failed to inject continuation
        }
      }

      if (event.type === "session.deleted") {
        type SessionInfo = { id?: string }
        const sessionInfo = props?.info as SessionInfo | undefined
        if (sessionInfo?.id) {
          const state = readState(directory)
          if (state?.session_id === sessionInfo.id) {
            clearState(directory)
          }
        }
      }

      if (event.type === "session.error") {
        type ErrorInfo = { name?: string }
        const error = props?.error as ErrorInfo | undefined
        const sessionID = props?.sessionID as string | undefined

        if (error?.name === "MessageAbortedError" && sessionID) {
          const state = readState(directory)
          if (state?.session_id === sessionID) {
            clearState(directory)
          }
        }
      }
    },
  }
}
