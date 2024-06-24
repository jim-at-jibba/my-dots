-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.conceallevel = 0
vim.g.lazyvim_python_lsp = "basedpyright"
