-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("i", "jj", "<Esc>", { desc = "Esc" })
vim.keymap.set("n", "H", "^", { desc = "Prev buffer" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center going up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center going down" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Center while going next" })
vim.keymap.set("n", "N", "nzzzv", { desc = "Center going prev" })
vim.keymap.set("n", "q", "<Nop>", { desc = "Nope" })
vim.keymap.set("i", "<C-n>", "<C-x><C-o>", { desc = "Open Omnifunc" })
vim.keymap.set({ "n", "v" }, "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set({ "n", "v" }, "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines up" })
vim.keymap.set("v", "<leader>p", '"_dP', { desc = "Best mapping ever" })
vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Trigger code action" })
vim.keymap.set(
  "n",
  "<leader>dl",
  "<cmd>lua vim.diagnostic.open_float({scope='line'})<CR>",
  { desc = "Line diagnostic" }
)
vim.keymap.set("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Go to next error" })
vim.keymap.set("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "Go to prev error" })
vim.keymap.set("n", "<leader>gh", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "LSP Hover" })
vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename" })
vim.keymap.set("n", "Y", "y$", { desc = "Yank whole line" })
vim.keymap.set("n", "<leader><leader>", "<c-^>", { desc = "Goto prev buffer" })
vim.keymap.set("n", "<leader>.", "<cmd>TSLspImportAll<CR>", { desc = "Import all" })

--Telescope
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers preview=true<CR>", { desc = "Telescope buffer" })
vim.keymap.set("n", "<leader>f", "<cmd>Telescope live_grep preview=true<CR>", { desc = "Telescope Live grep" })
vim.keymap.set("n", "<C-p>", "<cmd>Telescope git_files preview=true<CR>", { desc = "FInd git files" })
vim.keymap.set("n", "<leader>g", "<cmd>Telescope git_status preview=true<CR>", { desc = "Git status" })
vim.keymap.set("n", "<leader>dr", "<cmd>Telescope lsp_references<CR>", { desc = "Lsp references" })
vim.keymap.set("n", "<leader>de", "<cmd>Telescope diagnostics<CR>", { desc = "Telescope diagnostic" })
vim.keymap.set("n", "<leader>tw", "<cmd>Telescope tailiscope<CR>", { desc = "Telescope tailiscope" })

vim.keymap.set("n", "<leader>S", ":lua require('spectre').open()<cr>", { desc = "Spectre search" })
