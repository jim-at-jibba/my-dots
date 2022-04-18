local map = vim.keymap.set
default_options = { silent = true, noremap = true }
expr_options = { expr = true, silent = true }

--Remap space as leader key
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

--Telescope
map("n", "<leader>b", ":Telescope buffers preview=true<CR>", opts)
map("n", "<leader>f", ":Telescope live_grep preview=true<CR>", opts)
map("n", "<C-p>", ":Telescope git_files preview=true<CR>", opts)
map("n", "<leader>g", ":Telescope git_commits preview=true<CR>", opts)

--Nvimtree
map("n", "<leader><leader>1", ":NvimTreeToggle<CR>", opts)
map("n", "<leader>r", ":NvimTreeRefresh<CR>", opts)

map("n", "<leader>gs", ":LazyGit<CR>", opts)

--BarBar
map('n', '<leader>1', ':BufferGoto 1<CR>', opts)
map('n', '<leader>2', ':BufferGoto 2<CR>', opts)
map('n', '<leader>3', ':BufferGoto 3<CR>', opts)
map('n', '<leader>4', ':BufferGoto 4<CR>', opts)
map('n', '<leader>5', ':BufferGoto 5<CR>', opts)
map('n', '<leader>6', ':BufferGoto 6<CR>', opts)
map('n', '<leader>7', ':BufferGoto 7<CR>', opts)
map('n', '<leader>8', ':BufferGoto 8<CR>', opts)
map('n', '<leader>9', ':BufferGoto 9<CR>', opts)
map('n', '<leader>0', ':BufferLast<CR>', opts)
-- Close buffer
map('n', '<leader>q', ':BufferClose<CR>', opts)