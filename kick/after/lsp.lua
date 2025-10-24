vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  callback = function(args)
    require('jdtls.jdtls_setup').setup()
  end,
})
