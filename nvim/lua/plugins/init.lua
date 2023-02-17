return {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "danielvolchek/tailiscope.nvim" },
    {
        "folke/todo-comments.nvim",
        config = true,
    },
    {
        "echasnovski/mini.nvim",
        config = function()
          require("mini.comment").setup({
              hooks = {
                  pre = function()
                    require("ts_context_commentstring.internal").update_commentstring()
                  end,
              },
          })
        end,
    },
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    {
        "echasnovski/mini.indentscope",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
          vim.api.nvim_create_autocmd("FileType", {
              pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
              callback = function()
                vim.b.miniindentscope_disable = true
              end,
          })
          require("mini.indentscope").setup({
              options = {
                  try_as_border = true,
              },
          })
        end,
    },
    {
        "ggandor/leap.nvim",
        config = function()
          require("leap").add_default_mappings()
        end,
    },
    {
        "ggandor/flit.nvim",
        config = function()
          require("flit").setup({
              labeled_modes = "nv",
          })
        end,
    },
    { "cohama/lexima.vim" },
    { "szw/vim-maximizer" },
    {
        "windwp/nvim-ts-autotag",
    },
    {
        "crispgm/nvim-go",
        config = function()
          require("go").setup({
              notify = true,
              auto_lint = false,
              lint_prompt_style = "ql",
          })
        end,
    },
    {
        "alexghergh/nvim-tmux-navigation",
        config = function()
          local nvim_tmux_nav = require("nvim-tmux-navigation")

          nvim_tmux_nav.setup({
              disable_when_zoomed = true, -- defaults to false
          })

          vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
          vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
          vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
          vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
          vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
          vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
        end,
    },

    { "PatschD/zippy.nvim" },
    { "mbbill/undotree" },
    {
        "lukas-reineke/indent-blankline.nvim",
        ft = { "python", "yml", "yaml" },
        config = function()
          require("indent_blankline").setup({
              char = "│",
              filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
              show_trailing_blankline_indent = false,
              show_current_context = false,
          })
        end,
    },

    {
        "norcalli/nvim-colorizer.lua",
        event = "BufReadPre",
        config = function()
          require("colorizer").setup({ "*" }, {
              RGB = true, -- #RGB hex codes
              RRGGBB = true, -- #RRGGBB hex codes
              RRGGBBAA = true, -- #RRGGBBAA hex codes
              rgb_fn = true, -- CSS rgb() and rgba() functions
              hsl_fn = true, -- CSS hsl() and hsla() functions
              css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
              css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
              namess = true, -- "Name" codes like Blue
          })
        end,
    },

    { "p00f/nvim-ts-rainbow" },
    {
        "windwp/nvim-spectre",
        -- stylua: ignore
        keys = {
            { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
        },
    },
    -- references
    {
        "RRethy/vim-illuminate",
        event = { "BufReadPost", "BufNewFile" },
        opts = { delay = 200 },
        config = function(_, opts)
          require("illuminate").configure(opts)
          vim.api.nvim_create_autocmd("FileType", {
              callback = function()
                local buffer = vim.api.nvim_get_current_buf()
                pcall(vim.keymap.del, "n", "]]", { buffer = buffer })
                pcall(vim.keymap.del, "n", "[[", { buffer = buffer })
              end,
          })
        end,
        -- stylua: ignore
        keys = {
            { "]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference", },
            { "[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev Reference" },
        },
    },

    -- buffer remove
    {
        "echasnovski/mini.bufremove",
        -- stylua: ignore
        keys = {
            { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
        },
    },
    {
        "SmiteshP/nvim-navic",
        dependencies = "neovim/nvim-lspconfig",
    },
}
