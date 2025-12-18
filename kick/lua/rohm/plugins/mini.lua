local my_active_content = function()
  local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
  local git = MiniStatusline.section_git { trunc_width = 40 }
  local diff = MiniStatusline.section_diff { trunc_width = 75 }
  local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
  local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
  local filename = MiniStatusline.section_filename { trunc_width = 140 }
  local grapple = require('grapple').statusline()

  -- sidekick status
  local sidekick_status = ''
  local sidekick_hl = 'MiniStatuslineDevinfo'
  local ok, status_module = pcall(require, 'sidekick.status')
  if ok then
    local status = status_module.get()
    if status then
      local icon = ' '
      sidekick_status = icon
      if status.kind == 'Error' then
        sidekick_hl = 'DiagnosticError'
      elseif status.busy then
        sidekick_hl = 'DiagnosticWarn'
      else
        sidekick_hl = 'Special'
      end
    end
  end

  return MiniStatusline.combine_groups {
    { hl = mode_hl, strings = { mode } },
    { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
    '%<', -- Mark general truncate point
    { hl = 'MiniStatuslineFilename', strings = { filename } },
    '%=', -- End left alignment
    { hl = sidekick_hl, strings = { sidekick_status } },
    { hl = mode_hl, strings = { grapple } },
  }
end

return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- require('mini.jump').setup {}

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { content = { active = my_active_content } }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
      require('mini.icons').setup()
      require('mini.pairs').setup()
      -- require('mini.files').setup()
      require('mini.cmdline').setup()
    end,
  },
}
