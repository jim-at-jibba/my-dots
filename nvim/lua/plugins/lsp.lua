local util = require("lspconfig/util")
local path = util.path
local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end
  -- Find and use virtualenv in workspace directory.
  for _, pattern in ipairs({ "*", ".*" }) do
    local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
    if match ~= "" then
      return path.join(path.dirname(match), "bin", "python")
    end
  end
  -- Fallback to system Python.
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

return {
  -- neodev
  {
    "folke/neodev.nvim",
    opts = {
      debug = true,
      experimental = {
        pathStrict = true,
      },
      library = {
        runtime = "~/projects/neovim/runtime/",
      },
    },
  },

  -- tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {},
    },
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type lspconfig.options
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        severity_sort = true,
      },
      servers = {
        cssls = {},
        dockerls = {},
        tsserver = {
          -- on_attach = function(client, bufnr)
          --   require("nvim-lsp-ts-utils").setup({})
          -- end,
        },
        eslint = {},
        html = {
          settings = {
            filetypes = {
              "html",
              "tmpl",
            },
          },
        },
        gopls = {
          settings = {
            { analyses = { unusedparams = true }, staticcheck = true },
          },
        },
        marksman = {},
        emmet_ls = {
          settings = {
            filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
            init_options = {
              html = {
                options = {
                  -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                  ["bem.enabled"] = true,
                },
              },
            },
          },
        },
        pyright = {
          before_init = function(_, config)
            print(vim.inspect(get_python_path(config.root_dir)))
            config.settings.python.pythonPath = get_python_path(config.root_dir)
          end,
        },
        yamlls = {},
        sumneko_lua = {
          -- cmd = { "/home/folke/projects/lua-language-server/bin/lua-language-server" },
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {
                  "--log-level=trace",
                },
              },
              diagnostics = {
                -- enable = false,
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
        -- tailwindcss = {},
      },
    },
  },
}
