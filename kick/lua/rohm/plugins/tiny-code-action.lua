return {
  {
    'rachartier/tiny-code-action.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    event = 'LspAttach',
    opts = {
      --- The backend to use, currently only "vim", "delta", "difftastic", "diffsofancy" are supported
      backend = 'vim',

      -- The picker to use, "telescope", "snacks", "select", "buffer" are supported
      -- And it's opts that will be passed at the picker's creation, optional
      -- If you want to use the `fzf-lua` picker, you can simply set it to `select`
      --
      -- You can also set `picker = "<picker>"` without any opts.
      picker = 'telescope',
      backend_opts = {
        delta = {
          -- Header from delta can be quite large.
          -- You can remove them by setting this to the number of lines to remove
          header_lines_to_remove = 4,

          -- The arguments to pass to delta
          -- If you have a custom configuration file, you can set the path to it like so:
          -- args = {
          --     "--config" .. os.getenv("HOME") .. "/.config/delta/config.yml",
          -- }
          args = {
            '--line-numbers',
          },
        },
        difftastic = {
          header_lines_to_remove = 1,

          -- The arguments to pass to difftastic
          args = {
            '--color=always',
            '--display=inline',
            '--syntax-highlight=on',
          },
        },
        diffsofancy = {
          header_lines_to_remove = 4,
        },
      },

      -- The icons to use for the code actions
      -- You can add your own icons, you just need to set the exact action's kind of the code action
      -- You can set the highlight like so: { link = "DiagnosticError" } or  like nvim_set_hl ({ fg ..., bg..., bold..., ...})
      signs = {
        quickfix = { '', { link = 'DiagnosticWarning' } },
        others = { '', { link = 'DiagnosticWarning' } },
        refactor = { '', { link = 'DiagnosticInfo' } },
        ['refactor.move'] = { '󰪹', { link = 'DiagnosticInfo' } },
        ['refactor.extract'] = { '', { link = 'DiagnosticError' } },
        ['source.organizeImports'] = { '', { link = 'DiagnosticWarning' } },
        ['source.fixAll'] = { '󰃢', { link = 'DiagnosticError' } },
        ['source'] = { '', { link = 'DiagnosticError' } },
        ['rename'] = { '󰑕', { link = 'DiagnosticWarning' } },
        ['codeAction'] = { '', { link = 'DiagnosticWarning' } },
      },
    },
  },
}
