import type { Plugin } from "@opencode-ai/plugin";
import path from "node:path";

export const NotificationPlugin: Plugin = async ({
  project,
  client,
  $,
  directory,
  worktree,
}) => {
  const isGhosttyFocused = async (): Promise<boolean> => {
    const result =
      await $`osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true'`.text();
    return result.trim() === "Ghostty";
  };

  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        const dirName = path.basename(directory);
        const title = `OpenCode: ${dirName ?? "Project"}`;
        const message = "Session completed!";
        await $`osascript -e 'display notification "${message}" with title "${title}" sound name "Pop"'`;
      }
    },
  };
};
