lua << EOF

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  indent = {
    enable = true
  },
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust" },  -- list of language that will be disabled
  },
 -- refactor = {
 --   highlight_definitions = {
 --       enable = true
 --   }
 -- },
    autotag = {
      enable = true
    },
 -- matchup = {
 --   enable = true,              -- mandatory, false will disable the whole extension
 -- },
}

EOF
