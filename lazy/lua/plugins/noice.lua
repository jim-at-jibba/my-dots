return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      cmdline = {
        view = "cmdline", -- cmdline|cmdline_popup
        format = {
          search_down = { icon = "  ", view = "cmdline" }, -- FIX needs to be set explicitly
          cmdline = { view = "cmdline_popup" },
          lua = { view = "cmdline_popup" },
          help = { view = "cmdline_popup" },
          numb = { -- numb.nvim
            pattern = "^:%d+$",
            view = "cmdline",
            conceal = false,
          },
          IncRename = {
            pattern = "^:IncRename ",
            icon = " ",
            conceal = true,
            view = "cmdline_popup",
            opts = {
              relative = "cursor",
              size = { width = 30 }, -- `max_width` does not work, so fixed value
              position = { row = -3, col = 0 },
            },
          },
          substitute = { -- :s as a standalone popup
            view = "cmdline_popup",
            pattern = { "^:%%? ?s[ /]", "^:'<,'> ?s[ /]" },
            icon = " ",
            conceal = true,
          },
        },
      },
      commands = {
        -- options for `:Noice history`
        history = {
          view = "split",
          filter_opts = { reverse = true }, -- show newest entries first
          filter = {}, -- empty list = deactivate filter = include everything
          opts = {
            enter = true,
            -- https://github.com/folke/noice.nvim#-formatting
            format = { "{title} ", "{cmdline} ", "{message}" },
          },
        },
      },
      messages = {
        -- NOTE: If you enable messages, then the cmdline is enabled automatically.
        -- This is a current Neovim limitation.
        enabled = true, -- enables the Noice messages UI
        -- view = "mini", -- default view for messages
        -- view_error = "mini", -- view for errors
        -- view_warn = "mini", -- view for warnings
        view_history = "messages", -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
  -- stylua: ignore
  keys = {
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
    { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
    { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
    { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
  },
  },
}
