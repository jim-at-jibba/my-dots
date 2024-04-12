-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local delmap = vim.keymap.del
local opts = { silent = true, noremap = true }

-- --Remap space as leader key
-- map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

--General
map("i", "jj", "<Esc>", opts)
map("n", "H", "^", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "nzzzv", opts)
map("n", "L", "g_", opts)
map("n", "<Space>/", ":noh<cr>", opts)

map("n", "<Up>", "<Nop>", opts)
map("n", "<Down>", "<Nop>", opts)
map("n", "<Left>", "<Nop>", opts)
map("n", "<Down>", "<Nop>", opts)

-- map("n", "<C-J>", "<C-W><C-J>", opts)
-- map("n", "<C-K>", "<C-W><C-K>", opts)
map("n", "<C-H>", "<C-W><C-H>", opts)
map("n", "<C-L>", "<C-W><C-L>", opts)
map("n", "<leader>+", ":vertical resize +5<cr>", opts)
map("n", "<leader>-", ":vertical resize -5<cr>", opts)
map("i", "<C-n>", "<C-x><C-o>", opts)

map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- map({ "n", "v" }, "<leader>y", '"+y', opts)

map({ "n", "v" }, "K", ":m '<-2<CR>gv=gv", opts)
map({ "n", "v" }, "J", ":m '>+1<CR>gv=gv", opts)

map("v", "<leader>p", '"_dP', opts)

map("n", "Y", "y$", opts)
-- map("n", "<leader>6", "<c-^>", opts)
map("n", "<leader><leader>", "<c-^>", opts)

map("t", "<Esc>", "<C-\\><C-n>", opts)

map("n", "dw", "ciw", opts)
vim.cmd("cnoreabbrev W! w!")
vim.cmd("cnoreabbrev Q! q!")
vim.cmd("cnoreabbrev Qall! qall!")
vim.cmd("cnoreabbrev Wq wq")
vim.cmd("cnoreabbrev Wa wa")
vim.cmd("cnoreabbrev wQ wq")
vim.cmd("cnoreabbrev WQ wq")
vim.cmd("cnoreabbrev W w")

delmap("n", "<C-h>")
delmap("n", "<C-j>")
delmap("n", "<C-k>")
delmap("n", "<C-l>")

local nvim_tmux_nav = require("nvim-tmux-navigation")
vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
