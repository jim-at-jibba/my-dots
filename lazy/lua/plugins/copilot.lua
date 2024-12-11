local mapping_key_prefix = "<leader>A"
local SYSTEM_PROMPT = string.format(
  [[You are an AI programming assistant named "Claude Sonnet".
You are currently plugged in to the Neovim text editor on a user's machine.

Your tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Ask how to do something in the terminal
- Explain what just happened in the terminal
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
- The user is working on a %s machine. Please respond with system specific commands if applicable.

When given a task:
1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
2. Output the code in a single code block.
3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
4. You can only give one reply for each conversation turn.
5. The active document is the source code the user is looking at right now.
]],
  vim.loop.os_uname().sysname
)
local CLAUDE_EXPLAIN = string.format(
  [[You are a world-class coding tutor. Your code explanations perfectly balance high-level concepts and granular details. Your approach ensures that students not only understand how to write code, but also grasp the underlying principles that guide effective programming.
When asked for your name, you must respond with "GitHub Copilot".
Follow the user's requirements carefully & to the letter.
Your expertise is strictly limited to software development topics.
Follow Microsoft content policies.
Avoid content that violates copyrights.
For questions not related to software development, simply give a reminder that you are an AI programming assistant.
Keep your answers short and impersonal.
Use Markdown formatting in your answers.
Make sure to include the programming language name at the start of the Markdown code blocks.
Avoid wrapping the whole response in triple backticks.
The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal.
The active document is the source code the user is looking at right now.
You can only give one reply for each conversation turn.

Additional Rules
Think step by step:
1. Examine the provided code selection and any other context like user question, related errors, project details, class definitions, etc.
2. If you are unsure about the code, concepts, or the user's question, ask clarifying questions.
3. If the user provided a specific question or error, answer it based on the selected code and additional provided context. Otherwise focus on explaining the selected code.
4. Provide suggestions if you see opportunities to improve code readability, performance, etc.

Focus on being clear, helpful, and thorough without assuming extensive prior knowledge.
Use developer-friendly terms and analogies in your explanations.
Identify 'gotchas' or less obvious parts of the code that might trip up someone new.
Provide clear and relevant examples aligned with any provided context.
]]
)
local CLAUDE_REVIEW = string.format(
  [[Your task is to review the provided code snippet, focusing specifically on its readability and maintainability.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.

Your feedback must be concise, directly addressing each identified issue with:
- A clear description of the problem.
- A concrete suggestion for how to improve or correct the issue.

Format your feedback as follows:
- Explain the high-level issue or problem briefly.
- Provide a specific suggestion for improvement.

If the code snippet has no readability issues, simply confirm that the code is clear and well-written as is.
]]
)
local CLAUDE_REFACTOR = string.format(
  [[Your task is to refactor the provided code snippet, focusing specifically on its readability and maintainability.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.
]]
)

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-e>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { mapping_key_prefix, group = "AI Code Companion", mode = { "n", "v" } },
      },
    },
  },
  -- {
  --   "olimorris/codecompanion.nvim",
  --   opts = {
  --     display = {
  --       chat = {
  --         -- Change to true to show the current model
  --         show_settings = true,
  --         window = {
  --           layout = "vertical", -- float|vertical|horizontal|buffer
  --         },
  --       },
  --     },
  --     opts = {
  --       log_level = "DEBUG",
  --       system_prompt = SYSTEM_PROMPT,
  --     },
  --     prompt_library = {
  --       -- Custom the default prompt
  --       ["Generate a Commit Message"] = {
  --         prompts = {
  --           {
  --             role = "user",
  --             content = function()
  --               return "Write commit message with commitizen convention. Write clear, informative commit messages that explain the 'what' and 'why' behind changes, not just the 'how'."
  --                 .. "\n\n```\n"
  --                 .. vim.fn.system("git diff")
  --                 .. "\n```"
  --             end,
  --             opts = {
  --               contains_code = true,
  --             },
  --           },
  --         },
  --       },
  --       ["Explain"] = {
  --         strategy = "chat",
  --         description = "Explain how code in a buffer works",
  --         opts = {
  --           index = 4,
  --           default_prompt = true,
  --           modes = { "v" },
  --           short_name = "explain",
  --           auto_submit = true,
  --           user_prompt = false,
  --           stop_context_insertion = true,
  --         },
  --         prompts = {
  --           {
  --             role = "system",
  --             content = CLAUDE_EXPLAIN,
  --             opts = {
  --               visible = false,
  --             },
  --           },
  --           {
  --             role = "user",
  --             content = function(context)
  --               local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
  --
  --               return "Please explain how the following code works:\n\n```"
  --                 .. context.filetype
  --                 .. "\n"
  --                 .. code
  --                 .. "\n```\n\n"
  --             end,
  --             opts = {
  --               contains_code = true,
  --             },
  --           },
  --         },
  --       },
  --       -- Add custom prompts
  --       ["Generate a Commit Message for Staged"] = {
  --         strategy = "chat",
  --         description = "Generate a commit message for staged change",
  --         opts = {
  --           index = 9,
  --           short_name = "staged-commit",
  --           auto_submit = true,
  --         },
  --         prompts = {
  --           {
  --             role = "user",
  --             content = function()
  --               return "Write commit message for the change with commitizen convention. Write clear, informative commit messages that explain the 'what' and 'why' behind changes, not just the 'how'."
  --                 .. "\n\n```\n"
  --                 .. vim.fn.system("git diff --staged")
  --                 .. "\n```"
  --             end,
  --             opts = {
  --               contains_code = true,
  --             },
  --           },
  --         },
  --       },
  --       ["Inline-Document"] = {
  --         strategy = "inline",
  --         description = "Add documentation for code.",
  --         opts = {
  --           modes = { "v" },
  --           short_name = "inline-doc",
  --           auto_submit = true,
  --           user_prompt = false,
  --           stop_context_insertion = true,
  --         },
  --         prompts = {
  --           {
  --             role = "user",
  --             content = function(context)
  --               local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
  --
  --               return "Please provide documentation in comment code for the following code and suggest to have better naming to improve readability.\n\n```"
  --                 .. context.filetype
  --                 .. "\n"
  --                 .. code
  --                 .. "\n```\n\n"
  --             end,
  --             opts = {
  --               contains_code = true,
  --             },
  --           },
  --         },
  --       },
  --       ["Document"] = {
  --         strategy = "chat",
  --         description = "Write documentation for code.",
  --         opts = {
  --           modes = { "v" },
  --           short_name = "doc",
  --           auto_submit = true,
  --           user_prompt = false,
  --           stop_context_insertion = true,
  --         },
  --         prompts = {
  --           {
  --             role = "user",
  --             content = function(context)
  --               local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
  --
  --               return "Please brief how it works and provide documentation in comment code for the following code. Also suggest to have better naming to improve readability.\n\n```"
  --                 .. context.filetype
  --                 .. "\n"
  --                 .. code
  --                 .. "\n```\n\n"
  --             end,
  --             opts = {
  --               contains_code = true,
  --             },
  --           },
  --         },
  --       },
  --       ["Review"] = {
  --         strategy = "chat",
  --         description = "Review the provided code snippet.",
  --         opts = {
  --           index = 11,
  --           modes = { "v" },
  --           short_name = "review",
  --           auto_submit = true,
  --           user_prompt = false,
  --           stop_context_insertion = true,
  --         },
  --         prompts = {
  --           {
  --             role = "system",
  --             content = CLAUDE_REVIEW,
  --             opts = {
  --               visible = false,
  --             },
  --           },
  --           {
  --             role = "user",
  --             content = function(context)
  --               local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
  --
  --               return "Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability:\n\n```"
  --                 .. context.filetype
  --                 .. "\n"
  --                 .. code
  --                 .. "\n```\n\n"
  --             end,
  --             opts = {
  --               contains_code = true,
  --             },
  --           },
  --         },
  --       },
  --       ["Refactor"] = {
  --         strategy = "inline",
  --         description = "Refactor the provided code snippet.",
  --         opts = {
  --           index = 11,
  --           modes = { "v" },
  --           short_name = "refactor",
  --           auto_submit = true,
  --           user_prompt = false,
  --           stop_context_insertion = true,
  --         },
  --         prompts = {
  --           {
  --             role = "system",
  --             content = CLAUDE_REFACTOR,
  --             opts = {
  --               visible = false,
  --             },
  --           },
  --           {
  --             role = "user",
  --             content = function(context)
  --               local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
  --
  --               return "Please refactor the following code to improve its clarity and readability:\n\n```"
  --                 .. context.filetype
  --                 .. "\n"
  --                 .. code
  --                 .. "\n```\n\n"
  --             end,
  --             opts = {
  --               contains_code = true,
  --             },
  --           },
  --         },
  --       },
  --       ["Naming"] = {
  --         strategy = "inline",
  --         description = "Give betting naming for the provided code snippet.",
  --         opts = {
  --           index = 12,
  --           modes = { "v" },
  --           short_name = "naming",
  --           auto_submit = true,
  --           user_prompt = false,
  --           stop_context_insertion = true,
  --         },
  --         prompts = {
  --           {
  --             role = "user",
  --             content = function(context)
  --               local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
  --
  --               return "Please provide better names for the following variables and functions:\n\n```"
  --                 .. context.filetype
  --                 .. "\n"
  --                 .. code
  --                 .. "\n```\n\n"
  --             end,
  --             opts = {
  --               contains_code = true,
  --             },
  --           },
  --         },
  --       },
  --     },
  --     adapters = {
  --       anthropic = function()
  --         return require("codecompanion.adapters").extend("anthropic", {
  --           schema = {
  --             model = {
  --               default = "claude-3-5-sonnet-20240620",
  --             },
  --           },
  --         })
  --       end,
  --     },
  --     strategies = {
  --       chat = {
  --         adapter = "anthropic",
  --         roles = { llm = "  Claude Chat", user = "Besty" },
  --       },
  --       inline = {
  --         adapter = "anthropic",
  --       },
  --       agent = {
  --         adapter = "anthropic",
  --       },
  --     },
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
  --     "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
  --     { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For prettier markdown rendering
  --     { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
  --   },
  --   keys = {
  --     { mapping_key_prefix .. "a", "<cmd>CodeCompanionChat<CR>", desc = "Toggle codecompanion chat window" },
  --     { mapping_key_prefix .. "e", "<cmd>CodeCompanion<CR>", desc = "Toggle codecompanion inline" },
  --     { mapping_key_prefix .. "c", "<cmd>CodeCompanionActions<CR>", desc = "CodeCompanion actions" },
  --     { mapping_key_prefix .. "g", "<cmd>CodeCompanionChat Add<CR>", desc = "CodeCompanion Add" },
  --     {
  --       mapping_key_prefix .. "x",
  --       "<cmd>CodeCompanionChat /explain<CR>",
  --       desc = "CodeCompanion Explain code",
  --       mode = { "v" },
  --     },
  --     { mapping_key_prefix .. "f", "<cmd>CodeCompanionChat /fix<CR>", desc = "CodeCompanion Fix code", mode = { "v" } },
  --     {
  --       mapping_key_prefix .. "l",
  --       "<cmd>CodeCompanionChat /lsp<CR>",
  --       desc = "CodeCompanion Explain LSP diagnostics",
  --       mode = { "v", "n" },
  --     },
  --     {
  --       mapping_key_prefix .. "r",
  --       "<cmd>CodeCompanionChat /refactor<CR>",
  --       desc = "CodeCompanion Refactor code",
  --       mode = { "v" },
  --     },
  --     {
  --       mapping_key_prefix .. "R",
  --       "<cmd>CodeCompanionChat /review<CR>",
  --       desc = "CodeCompanion Review code",
  --       mode = { "v" },
  --     },
  --     {
  --       mapping_key_prefix .. "m",
  --       "<cmd>CodeCompanionChat /commit<CR>",
  --       desc = "CodeCompanion Git commit message",
  --       mode = { "v" },
  --     },
  --     {
  --       mapping_key_prefix .. "t",
  --       "<cmd>CodeCompanionChat /tests<CR>",
  --       desc = "CodeCompanion Generate tests",
  --       mode = { "v" },
  --     },
  --     {
  --       mapping_key_prefix .. "M",
  --       "<cmd>CodeCompanionChat /staged-commit<CR>",
  --       desc = "CodeCompanion Git commit message(staged) ",
  --       mode = { "v" },
  --     },
  --     {
  --       mapping_key_prefix .. "d",
  --       "<cmd>CodeCompanionChat /inline-doc<CR>",
  --       desc = "CodeCompanion Inline document code",
  --       mode = { "v" },
  --     },
  --     {
  --       mapping_key_prefix .. "D",
  --       "<cmd>CodeCompanionChat /doc<CR>",
  --       desc = "CodeCompanion document code",
  --       mode = { "v" },
  --     },
  --     {
  --       mapping_key_prefix .. "n",
  --       "<cmd>CodeCompanionChat /naming<CR>",
  --       desc = "CodeCompanion Better ",
  --       mode = { "v" },
  --     },
  --   },
  --   config = function(_, options)
  --     require("codecompanion").setup(options)
  --
  --     -- Expand 'cc' into 'CodeCompanion' in the command line
  --     vim.cmd([[cab cc CodeCompanion]])
  --   end,
  -- },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   event = "VeryLazy",
  --   cmd = "Copilot",
  --   build = ":Copilot auth",
  --   opts = {
  --     suggestion = { enabled = true },
  --     panel = { enabled = false },
  --     filetypes = {
  --       markdown = true,
  --       help = true,
  --       gleam = false,
  --     },
  --   },
  -- },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   branch = "canary",
  --   event = "VeryLazy",
  --   dependencies = {
  --     { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
  --     { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  --   },
  --   config = function(_, opts)
  --     local chat = require("CopilotChat")
  --     local select = require("CopilotChat.select")
  --     -- Use unnamed register for the selection
  --     opts.selection = select.unnamed
  --
  --     chat.setup(opts)
  --
  --     vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
  --       chat.ask(args.args, { selection = select.visual })
  --     end, { nargs = "*", range = true })
  --
  --     -- Inline chat with Copilot
  --     vim.api.nvim_create_user_command("CopilotChatInline", function(args)
  --       chat.ask(args.args, {
  --         selection = select.visual,
  --         window = {
  --           layout = "float",
  --           relative = "cursor",
  --           width = 1,
  --           height = 0.4,
  --           row = 1,
  --         },
  --       })
  --     end, { nargs = "*", range = true })
  --
  --     -- Restore CopilotChatBuffer
  --     vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
  --       chat.ask(args.args, { selection = select.buffer })
  --     end, { nargs = "*", range = true })
  --
  --     -- Custom buffer for CopilotChat
  --     vim.api.nvim_create_autocmd("BufEnter", {
  --       pattern = "copilot-*",
  --       callback = function()
  --         vim.opt_local.relativenumber = true
  --         vim.opt_local.number = true
  --
  --         -- Get current filetype and set it to markdown if the current filetype is copilot-chat
  --         local ft = vim.bo.filetype
  --         if ft == "copilot-chat" then
  --           vim.bo.filetype = "markdown"
  --         end
  --       end,
  --     })
  --   end,
  --   keys = {
  --     { "<leader>nc", "<cmd>CopilotChatToggle<CR>", desc = "Toggle copilot chat window" },
  --     { "<leader>cR", "<cmd>CopilotChatReset<CR>", desc = "Reset copilot chat window" },
  --     -- Show help actions with telescope
  --     {
  --       "<leader>ah",
  --       function()
  --         local actions = require("CopilotChat.actions")
  --         require("CopilotChat.integrations.telescope").pick(actions.help_actions())
  --       end,
  --       desc = "CopilotChat - Help actions",
  --     },
  --     -- Show prompts actions with telescope
  --     {
  --       "<leader>ap",
  --       function()
  --         local actions = require("CopilotChat.actions")
  --         require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
  --       end,
  --       desc = "CopilotChat - Prompt actions",
  --     },
  --     {
  --       "<leader>ap",
  --       ":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
  --       mode = "x",
  --       desc = "CopilotChat - Prompt actions",
  --     },
  --     -- Code related commands
  --     { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
  --     { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
  --     { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
  --     { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
  --     { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
  --     -- Chat with Copilot in visual mode
  --     {
  --       "<leader>av",
  --       ":CopilotChatVisual",
  --       mode = "x",
  --       desc = "CopilotChat - Open in vertical split",
  --     },
  --     {
  --       "<leader>ax",
  --       ":CopilotChatInline<cr>",
  --       mode = "x",
  --       desc = "CopilotChat - Inline chat",
  --     },
  --     -- Custom input for CopilotChat
  --     {
  --       "<leader>ai",
  --       function()
  --         local input = vim.fn.input("Ask Copilot: ")
  --         if input ~= "" then
  --           vim.cmd("CopilotChat " .. input)
  --         end
  --       end,
  --       desc = "CopilotChat - Ask input",
  --     },
  --     -- Generate commit message based on the git diff
  --     {
  --       "<leader>am",
  --       "<cmd>CopilotChatCommit<cr>",
  --       desc = "CopilotChat - Generate commit message for all changes",
  --     },
  --     {
  --       "<leader>aM",
  --       "<cmd>CopilotChatCommitStaged<cr>",
  --       desc = "CopilotChat - Generate commit message for staged changes",
  --     },
  --     -- Quick chat with Copilot
  --     {
  --       "<leader>aq",
  --       function()
  --         local input = vim.fn.input("Quick Chat: ")
  --         if input ~= "" then
  --           vim.cmd("CopilotChatBuffer " .. input)
  --         end
  --       end,
  --       desc = "CopilotChat - Quick chat",
  --     },
  --     -- Debug
  --     { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
  --     -- Fix the issue with diagnostic
  --     { "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
  --     -- Clear buffer and chat history
  --     { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
  --     -- Toggle Copilot Chat Vsplit
  --     { "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
  --   },
  --   opts = {
  --     debug = false, -- Enable debugging
  --     -- See Configuration section for rest
  --     -- window = {
  --     --   layout = "float",
  --     --   relative = "cursor",
  --     --   width = 1,
  --     --   height = 0.4,
  --     --   row = 1,
  --     -- },
  --   },
  --   -- See Commands section for default commands if you want to lazy load on them
  -- },
}
