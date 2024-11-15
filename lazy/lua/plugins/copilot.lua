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
  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-telescope/telescope.nvim", -- Optional
  --     {
  --       "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
  --     },
  --   },
  --   opts = {},
  --   keys = {
  --     { "<leader>aa", "<cmd>CodeCompanionChat<CR>", desc = "Toggle codecompanion chat window" },
  --     { "<leader>ai", "<cmd>CodeCompanion<CR>", desc = "Toggle codecompanion inline" },
  --     { "<leader>ac", "<cmd>CodeCompanionActions<CR>", desc = "CodeCompanion actions" },
  --     { "<leader>ga", "<cmd>CodeCompanionChat Add<CR>", desc = "CodeCompanion Add" },
  --   },
  --   config = function()
  --     require("codecompanion").setup({
  --       display = {
  --         diff = {
  --           provider = "mini_diff",
  --         },
  --       },
  --       adapters = {
  --         anthropic = function()
  --           return require("codecompanion.adapters").extend("anthropic", {
  --             schema = {
  --               model = {
  --                 default = "claude-3-5-sonnet-20240620",
  --               },
  --             },
  --           })
  --         end,
  --       },
  --       strategies = {
  --         chat = {
  --           adapter = "anthropic",
  --         },
  --         inline = {
  --           adapter = "anthropic",
  --         },
  --         agent = {
  --           adapter = "anthropic",
  --         },
  --       },
  --     })
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
