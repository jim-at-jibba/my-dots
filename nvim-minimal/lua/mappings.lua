local map = vim.keymap.set
local opts = { silent = true, noremap = true }

--Remap space as leader key
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

--General
map("i", "jj", "<Esc>", opts)
map("n", "H", "^", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "nzzzv", opts)
map("n", "L", "g_", opts)
-- map("n", "q", "<Nop>", opts)
map("n", "<Space>/", ":noh<cr>", opts)

map("n", "<Up>", "<Nop>", opts)
map("n", "<Down>", "<Nop>", opts)
map("n", "<Left>", "<Nop>", opts)
map("n", "<Down>", "<Nop>", opts)

-- map("n", "<C-J>", "<C-W><C-J>", opts)
-- map("n", "<C-K>", "<C-W><C-K>", opts)
map("n", "<C-H>", "<C-W><C-H>", opts)
map("n", "<C-L>", "<C-W><C-L>", opts)
map("n", "<leader>+", ":vertical resize +5", opts)
map("n", "<leader>-", ":vertical resize -5", opts)
map("i", "<C-n>", "<C-x><C-o>", opts)

map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

map({ "n", "v" }, "<leader>y", '"+y', opts)

map({ "n", "v" }, "K", ":m '<-2<CR>gv=gv", opts)
map({ "n", "v" }, "J", ":m '>+1<CR>gv=gv", opts)

map("v", "<leader>p", '"_dP', opts)

map("n", "Y", "y$", opts)
-- map("n", "<leader>6", "<c-^>", opts)
map("n", "<leader><leader>", "<c-^>", opts)

map("n", "<leader><leader>x", ':lua require("utils").declutter_terminal()<CR>', opts)
map("n", "<leader><leader>c", ':lua require("utils").clutter_terminal()<CR>', opts)

map("n", "dw", "ciw", opts)
vim.cmd("cnoreabbrev W! w!")
vim.cmd("cnoreabbrev Q! q!")
vim.cmd("cnoreabbrev Qall! qall!")
vim.cmd("cnoreabbrev Wq wq")
vim.cmd("cnoreabbrev Wa wa")
vim.cmd("cnoreabbrev wQ wq")
vim.cmd("cnoreabbrev WQ wq")
vim.cmd("cnoreabbrev W w")
-- vim.cmd("cnoreabbrev Q q")
