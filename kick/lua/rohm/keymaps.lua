local map = vim.keymap.set
local delmap = vim.keymap.del
local opts = { silent = true, noremap = true }

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
map('i', 'jj', '<Esc>', opts)
map('n', 'H', '^', opts)
map('n', '<C-u>', '<C-u>zz', opts)
map('n', '<C-d>', '<C-d>zz', opts)
map('n', 'L', 'g_', opts)
map('v', '<leader>p', '"_dP', opts)
map('n', 'Y', 'y$', opts)
-- Yank relative path to clipboard
map('n', '<leader>yp', function()
  local relative_path = vim.fn.expand '%'
  vim.fn.setreg('+', relative_path)
  vim.notify('Yanked relative path: ' .. relative_path, vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = 'Yank relative path' })
map('n', '<leader>`', '<c-^>', opts)

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
map('n', '-', ':lua MiniFiles.open()<CR>', { desc = 'Open MiniFiles' })
