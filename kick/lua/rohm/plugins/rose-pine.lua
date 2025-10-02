return {
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require('rose-pine').setup {
        --- @usage 'auto'|'main'|'moon'|'dawn'
        variant = 'moon',
        --- @usage 'main'|'moon'|'dawn'
        dark_variant = 'moon',
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = true,
        disable_float_background = false,
        disable_italics = true,

        --- @usage string hex value or named color from rosepinetheme.com/palette
        groups = {
          background = 'base',
          background_nc = '_experimental_nc',
          panel = 'surface',
          panel_nc = 'base',
          border = 'highlight_med',
          comment = 'muted',
          link = 'iris',
          punctuation = 'subtle',

          error = 'love',
          hint = 'iris',
          info = 'foam',
          warn = 'gold',

          headings = {
            h1 = 'iris',
            h2 = 'foam',
            h3 = 'rose',
            h4 = 'gold',
            h5 = 'pine',
            h6 = 'foam',
          },
          -- or set all headings at once
          -- headings = 'subtle'
        },

        -- Change specific vim highlight groups
        -- https://github.com/rose-pine/neovim/wiki/Recipes
        highlight_groups = {
          -- ColorColumn = { bg = "rose" },

          -- Blend colours against the "base" background
          CursorLine = { bg = 'foam', blend = 10 },
          StatusLine = { fg = 'love', bg = 'love', blend = 10 },

          FloatBorder = { fg = 'surface', bg = 'surface' },
          NormalFloat = { bg = 'surface' },
          FloatTitle = { bg = 'surface' },

          TelescopeTitle = { fg = 'love', bold = true },
          TelescopePromptNormal = { bg = 'surface' },
          TelescopePromptBorder = { fg = 'surface', bg = 'surface' },
          TelescopeResultsNormal = { fg = 'text', bg = 'nc' },
          TelescopeResultsBorder = { fg = 'nc', bg = 'nc' },
          TelescopePreviewNormal = { fg = 'text', bg = 'overlay' },
          TelescopePreviewBorder = { fg = 'overlay', bg = 'overlay' },

          NoiceCmdLinePrompt = { fg = 'foam', bold = true },
          NoiceCmdlinePopup = { fg = 'iris', bg = 'nc' },
          NoiceCmdlinePopupBorder = { fg = 'nc', bg = 'nc' },
          NoiceMini = { fg = 'iris', bg = 'overlay' },
        },
      }
      -- vim.cmd 'colorscheme rose-pine'
    end,
  },
}
