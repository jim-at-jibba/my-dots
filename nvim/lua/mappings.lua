local map = vim.keymap.set
opts = { silent = true, noremap = true }

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

map("n", "<C-J>", "<C-W><C-J>", opts)
map("n", "<C-K>", "<C-W><C-K>", opts)
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

map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
map("n", "<leader>dl", "<cmd>lua vim.diagnostic.open_float({scope='line'})<CR>", opts)
map("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
map("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
map("n", "<leader>gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

map("n", "Y", "y$", opts)
map("n", "<leader><leader>", "<c-^>", opts)

map("n", "<leader>.", ":TypescriptAddMissingImports<CR>", opts)

map("n", "<leader>?", ":CheatSH<CR>", opts)

--Telescope
map("n", "<leader>b", ":Telescope buffers preview=true<CR>", opts)
map("n", "<leader>f", ":Telescope live_grep preview=true<CR>", opts)
map("n", "<C-p>", ":Telescope git_files preview=true<CR>", opts)
map("n", "<leader>g", ":Telescope git_status preview=true<CR>", opts)
map("n", "<leader>dr", ":Telescope lsp_references<CR>", opts)
map("n", "<leader>de", ":Telescope diagnostics<CR>", opts)
map("n", "<leader>tw", ":Telescope tailiscope<CR>", opts)

-- Diagnostics Show
map("n", "<leader>ds", ":DiagWindowShow<CR>", opts)

-- map("n", "<leader>gs", ":LazyGit<CR>", opts)

-- Cokeline
for i = 1, 9 do
	map("n", ("<Leader>%s"):format(i), ("<Plug>(cokeline-focus-%s)"):format(i), opts)
	map("n", ("<F%s"):format(i), ("<Plug>(cokeline-switch-%s)"):format(i), opts)
end

-- Close buffer
map("n", "<leader>q", ":b#|bd#<CR>", opts)

--vimtest
-- map("n", "tt", ":TestNearest<cr>", opts)
-- map("n", "tf", ":TestFile<cr>", opts)
-- map("n", "ts", ":TestSuite<cr>", opts)

map("n", "<leader>m", ":MaximizerToggle!<cr>", opts)

-- dap
map("n", "<leader>dc", ":lua require('dap').continue()<CR>")
map("n", "<leader>dv", ":lua require('dap').step_over()<CR>")
map("n", "<leader>di", ":lua require('dap').step_into()<CR>")
map("n", "<leader>do", ":lua require('dap').step_out()<CR>")
map("n", "<leader>db", ":lua require('dap').toggle_breakpoint()<CR>")
map("n", "<leader>de", ":lua require('dap').close()<CR>")
-- map("n", "<leader>db", ":lua require('dap').toggle_breakpoint()<CR>")

-- tests
map("n", "<leader>tf", ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>")
map("n", "<leader>tt", ":lua require('neotest').run.run()<CR>")
map("n", "<leader>ts", ":lua require('neotest').summary.toggle()<CR>")
map("n", "<leader>to", ":lua require('neotest').output.open({enter = true})<CR>")
-- nnoremap <silent><leader>nr <cmd>lua require("neotest").run(vim.fn.expand("%"))<CR>
-- nnoremap <silent><leader>ns <cmd>lua require("neotest").run(vim.fn.getcwd())<CR>
-- nnoremap <silent><leader>nn <cmd>lua require("neotest").run()<CR>
-- nnoremap <silent><leader>nd <cmd>lua require("neotest").run({strategy = "dap"})<CR>
-- nnoremap <silent><leader>na <cmd>lua require("neotest").attach()<CR>
-- nnoremap <silent><leader>no <cmd>lua require("neotest").output.open({ enter = true })<CR>
-- nnoremap <silent><leader>nO <cmd>lua require("neotest").output.open({enter = true, short = true})<CR>
-- nnoremap <silent><leader>np <cmd>lua require("neotest").summary.toggle()<CR>
map("n", "<leader>u", ":UndotreeToggle<CR>")

-- zippy
map("n", "<leader>l", "<cmd>lua require('zippy').insert_print()<CR>")
