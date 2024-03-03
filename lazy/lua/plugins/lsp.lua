return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
      },
      servers = {
        -- harper_ls = {},
        htmx = {},
      },
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- change a keymap
      -- disable a keymap
      keys[#keys + 1] = { "gd", false }
      keys[#keys + 1] = { "gr", false }
      keys[#keys + 1] = { "K", false }
      keys[#keys + 1] = { "<leader>cr", false }
      keys[#keys + 1] = {
        "<leader>dd",
        function()
          require("telescope.builtin").lsp_definitions({ reuse_win = true })
        end,
        desc = "Goto Definition",
        has = "definition",
      }
      keys[#keys + 1] = {
        "<leader>dr",
        "<cmd>Telescope lsp_references<cr>",
        desc = "References",
      }

      keys[#keys + 1] = { "<leader>gh", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Show docs (LSP)" }

      keys[#keys + 1] = {
        "<leader>dl",
        "<cmd>lua vim.diagnostic.open_float({ border = 'rounded', max_width = 100 })<CR>",
        desc = "Show live diagnostics (LSP)",
      }

      keys[#keys + 1] = {
        "<leader>dn",
        "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded', max_width = 100 })<CR>",
        desc = "Show live diagnostics (LSP)",
      }

      keys[#keys + 1] = {
        "<leader>dp",
        "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded', max_width = 100 })<CR>",
        desc = "Show live diagnostics (LSP)",
      }
      keys[#keys + 1] = {
        "<leader>dn",
        "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded', max_width = 100 })<CR>",
        desc = "Show live diagnostics (LSP)",
      }
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true })
    end,
  },
}
