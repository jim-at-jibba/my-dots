return {
  'brenoprata10/nvim-highlight-colors',
  config = function()
    require('nvim-highlight-colors').setup {
      ---Render style
      ---@usage 'background'|'foreground'|'virtual'
      render = 'virtual',
      virtual_symbol = '■',
      virtual_symbol_prefix = '',
      virtual_symbol_suffix = ' ',
      virtual_symbol_position = 'inline',
      enable_tailwind = true,
    }
  end,
}
