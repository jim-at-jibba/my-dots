local options = {
	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
	expandtab = true,
	smartindent = true,
	hlsearch = true,
	paste = false,
	number = true,
	hidden = true,
	errorbells = true,
	spell = false,
	splitbelow = true,
	splitright = true,
	relativenumber = true,
	nu = true,
	scrolloff = 8,
	completeopt = { "menu", "menuone", "noinsert", "noselect" },
	signcolumn = "yes",
	updatetime = 100,
	timeoutlen = 300,
	incsearch = true,
	showmode = true,
	foldenable = true,
	foldlevel = 99,
	foldmethod = "indent",
	-- foldmethod = "expr",
	-- foldexpr = "nvim_treesitter#foldexpr()",

	backup = false,
	writebackup = false,
	swapfile = false,
	termguicolors = true,
	cursorline = false,
	undodir = "/Users/jamesbest/.cache/nvim/undodir",
	laststatus = 0,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.shortmess:append("c")
vim.g.vim_json_warnings = false
