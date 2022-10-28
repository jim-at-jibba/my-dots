local map = vim.keymap.set
opts = { silent = true, noremap = true }

--Remap space as leader key
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

--General
map("i", "jj", "<Esc>", opts)
map("n", "H", "^", opts)
map("n", "L", "g_", opts)
map("n", "q", "<Nop>", opts)

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
map("n", "<leader>gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

map("n", "Y", "y$", opts)
map("n", "<leader><leader>", "<c-^>", opts)

map("n", "<leader>.", ":TSLspImportAll<CR>", opts)

map("n", "<leader>?", ":CheatSH<CR>", opts)

--Telescope
map("n", "<leader>b", ":Telescope buffers preview=true<CR>", opts)
map("n", "<leader>f", ":Telescope live_grep preview=true<CR>", opts)
map("n", "<C-p>", ":Telescope git_files preview=true<CR>", opts)
map("n", "<leader>g", ":Telescope git_status preview=true<CR>", opts)
map("n", "<leader>dr", ":Telescope lsp_references<CR>", opts)

--Nvimtree
map("n", "<leader><leader>1", ":NvimTreeToggle<CR>", opts)
map("n", "<leader>r", ":NvimTreeRefresh<CR>", opts)

--Neotree
-- map("n", "<leader><leader>1", ":Neotree filesystem reveal right<CR>", opts)
map("n", "<leader><leader>2", ":Neotree diagnostics reveal bottom<CR>", opts)

-- Diagnostics Show
map("n", "<leader>ds", ":DiagWindowShow<CR>", opts)

map("n", "<leader>gs", ":LazyGit<CR>", opts)

--BarBar
map("n", "<leader>1", ":BufferGoto 1<CR>", opts)
map("n", "<leader>2", ":BufferGoto 2<CR>", opts)
map("n", "<leader>3", ":BufferGoto 3<CR>", opts)
map("n", "<leader>4", ":BufferGoto 4<CR>", opts)
map("n", "<leader>5", ":BufferGoto 5<CR>", opts)
map("n", "<leader>6", ":BufferGoto 6<CR>", opts)
map("n", "<leader>7", ":BufferGoto 7<CR>", opts)
map("n", "<leader>8", ":BufferGoto 8<CR>", opts)
map("n", "<leader>9", ":BufferGoto 9<CR>", opts)
map("n", "<leader>0", ":BufferLast<CR>", opts)
-- Close buffer
map("n", "<leader>q", ":BufferClose<CR>", opts)

--Trouble
map("n", "<leader>xx", ":TroubleToggle<CR>", opts)
map("n", "<leader>xw", ":Trouble lsp<CR>", opts)
map("n", "<leader>xw", ":Trouble workspace_diagnostics<CR>", opts)
map("n", "<leader>xd", ":Trouble document_diagnostics<CR>", opts)
-- map("n", "<leader>dr", ":TroubleToggle lsp_references<CR>", opts)
map("n", "<leader>dn", ":lua require('trouble').next({skip_groups = true, jump = true})<CR>", opts)
map("n", "<leader>dp", ":lua require('trouble').previous({skip_groups = true, jump = true})<CR>", opts)

--spectre
map("n", "<leader>S", ":lua require('spectre').open()<cr>", opts)

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

-- telekasten
map("n", "<leader>zp", ":lua require('telekasten').panel()<CR>")
map("n", "<leader>zf", ":lua require('telekasten').find_notes()<CR>")
map("n", "<leader>zd", ":lua require('telekasten').find_daily_notes()<CR>")
map("n", "<leader>zg", ":lua require('telekasten').search_notes()<CR>")
map("n", "<leader>zz", ":lua require('telekasten').follow_link()<CR>")
map("n", "<leader>zi", ":lua require('telekasten').insert_link()<CR>")

-- map("n", "<leader>rn", "<cmd>Lspsaga rename<cr>", opts)
-- map("n", "<leader>gh", "<cmd>Lspsaga hover_doc<cr>", opts)
-- map("n", "<leader>gd", "<cmd>Lspsaga preview_definition<cr>", opts)
-- map("n", "<leader>ca", "<cmd>Lspsaga code_action<cr>", opts)
-- map("n", "<C-f>", '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', opts)
-- map("n", "<C-b>", '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<cr>', opts)
-- map("n", "<leader>dl", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
-- map("n", "<leader>dn", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
-- map("n", "<leader>dp", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)

-- Copilot
-- map("i", "<C-e>", "copilot#Accept('<CR>')", { expr = true, silent = true, noremap = true })
