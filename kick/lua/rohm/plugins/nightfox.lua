return {
  {
    'EdenEast/nightfox.nvim',
    lazy = true,
    config = function()
      require('nightfox').setup {
        options = {
          transparent = false, -- Disable setting background
          terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
          dim_inactive = false, -- Non focused panes set to alternative background
        },
        -- groups = {
        --   all = {
        --     ColorColumn = { bg = 'palette.bg1' },
        --
        --     -- Blend colours against the "base" background
        --     CursorLine = { bg = 'bg2' },
        --     StatusLine = { fg = 'pink', bg = 'pink', blend = '10' },
        --
        --     normalfloat = { bg = 'bg2' },
        --     FloatBorder = { fg = 'palette.bg2', bg = 'palette.bg2' },
        --     FloatTitle = { bg = 'palette.bg2' },
        --
        --     TelescopeTitle = { fg = 'pink', bold = 'true' },
        --     TelescopePromptNormal = { bg = 'bg2' },
        --     TelescopePromptBorder = { fg = 'bg2', bg = 'bg2' },
        --     TelescopeResultsNormal = { fg = 'white', bg = 'bg0' },
        --     TelescopeResultsBorder = { fg = 'bg0', bg = 'bg0' },
        --     TelescopePreviewNormal = { fg = 'white', bg = 'bg3' },
        --     TelescopePreviewBorder = { fg = 'bg3', bg = 'bg3' },
        --
        --     NoiceCmdLinePrompt = { fg = 'orange', bold = 'true' },
        --     NoiceCmdlinePopup = { fg = 'palette.magenta', bg = 'palette.bg2' },
        --     NoiceCmdlinePopupBorder = { fg = 'palette.bg2', bg = 'palette.bg2' },
        --     NoiceMini = { fg = 'orange', bg = 'bg2' },
        --     -- NoiceLspProgressSpinner = { bg = colors.theme.ui.bg },
        --     -- NoiceLspProgressClient = { bg = colors.theme.ui.bg },
        --     -- NoiceLspProgressTitle = { bg = colors.theme.ui.bg },
        --
        --     -- DiagnosticBorder = { fg = "surface", bg = "surface" },
        --     DiagnosticNormal = { bg = 'bg2', fg = 'bg2' },
        --     -- DiagnosticShowNormal = { fg = "surface", bg = "surface" },
        --     -- DiagnosticShowBorder = { bg = "surface" },
        --   },
        -- },
      }
    end,
  },
}
