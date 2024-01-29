vim.g.python_host_prog = "~/.pyenv/versions/neovim2/bin/python"
vim.g.python3_host_prog = "~/.pyenv/versions/neovim3/bin/python3"
local api = vim.api

-- Options START
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
	foldlevelstart = 99,
	foldmethod = "indent",
	foldcolumn = "1",
	-- foldmethod = "expr",
	-- foldexpr = "nvim_treesitter#foldexpr()",
	laststatus = 0,

	backup = false,
	writebackup = false,
	swapfile = false,
	termguicolors = true,
	cursorline = false,
	undodir = "/Users/jamesbest/.cache/nvim/undodir",
	-- laststatus = 0,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.shortmess:append("c")
vim.g.vim_json_warnings = false

-- Options END

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

require("lazy").setup({
	-- ai start
	{
		"dustinblackman/oatmeal.nvim",
		cmd = { "Oatmeal" },
		keys = {
			{ "<leader>om", mode = "n", desc = "Start Oatmeal session" },
		},
		opts = {
			backend = "ollama",
			model = "codellama:latest",
		},
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				filetypes = {
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					go = false,
					rust = false,
					elixir = false,
					["."] = true,
				},
				panel = {
					enabled = true,
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<C-e>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
			})
		end,
	},
	-- ai end
	-- cmp start
	{ "onsails/lspkind-nvim", dependencies = { "famiu/bufdelete.nvim" } },
	{
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-emoji" },
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			lspkind.init({
				symbol_map = {
					Boolean = "[] Boolean",
					Character = "[] Character",
					Class = "[] Class",
					Color = "[] Color",
					Constant = "[] Constant",
					Constructor = "[] Constructor",
					Enum = "[] Enum",
					EnumMember = "[] EnumMember",
					Event = "[ﳅ] Event",
					Field = "[] Field",
					File = "[] File",
					Folder = "[ﱮ] Folder",
					Function = "[ﬦ] Function",
					Interface = "[] Interface",
					Keyword = "[] Keyword",
					Method = "[] Method",
					Module = "[] Module",
					Number = "[] Number",
					Operator = "[Ψ] Operator",
					Parameter = "[] Parameter",
					Property = "[ﭬ] Property",
					Reference = "[] Reference",
					Snippet = "[] Snippet",
					String = "[] String",
					Struct = "[ﯟ] Struct",
					Text = "[] Text",
					TypeParameter = "[] TypeParameter",
					Unit = "[] Unit",
					Value = "[] Value",
					Variable = "[ﳛ] Variable",
					Copilot = "[]",
				},
			})

			cmp.setup({
				window = {
					completion = {
						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
						col_offset = -3,
						side_padding = 0,
					},
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, item)
						local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, item)

						local strings = vim.split(kind.kind, "%s", { trimempty = true })
						kind.kind = " " .. (strings[1] or "") .. " "
						kind.menu = "    (" .. (strings[2] or "") .. ")"

						return kind
					end,
				},
				experimental = { native_menu = false, ghost_text = false },
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-u>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					-- ["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = false,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_prev_item()
						end
					end, { "i", "s" }),
				},
				sources = {
					{ name = "nvim_lsp" },
					-- { name = "copilot" },
					{ name = "buffer", keyword_length = 5 },
					{ name = "luasnip" },
					{ name = "emoji" },
					{ name = "path" },
				},
			})
		end,
	},
	-- luasnip
	{ "rafamadriz/friendly-snippets", event = "VeryLazy" },
	{
		"L3MON4D3/LuaSnip",
		event = "VeryLazy",
		dependencies = "saadparwaiz1/cmp_luasnip",
		config = function()
			local ls = require("luasnip")
			local vsc = require("luasnip.loaders.from_vscode")
			local lua = require("luasnip.loaders.from_lua")

			ls.filetype_extend("javascript", { "html" })
			ls.filetype_extend("javascriptreact", { "html" })
			ls.filetype_extend("typescript", { "html" })
			ls.filetype_extend("typescriptreact", { "html" })
			ls.filetype_extend("htmldjango", { "html" })
			ls.filetype_extend("django-html", { "html" })
			ls.filetype_extend("python", { "django" })

			vsc.lazy_load()
			vim.keymap.set({ "i", "s" }, "<c-j>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<c-k>", function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end, { silent = true })

			vim.keymap.set("i", "<c-h>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end)
		end,
	},
	-- cmp end
}, {
	defaults = { version = false },
	install = { colorscheme = { "rose-pine" } },
})

-- Vim mappings, see lua/config/which.lua for more mappings
local map = vim.keymap.set
local opts = { silent = true, noremap = true }

--Remap space as leader key
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

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

-- Autocommands START
--- Remove all trailing whitespace on save
local TrimWhiteSpaceGrp = api.nvim_create_augroup("TrimWhiteSpaceGrp", { clear = true })
api.nvim_create_autocmd("BufWritePre", {
	command = [[:%s/\s\+$//e]],
	group = TrimWhiteSpaceGrp,
})

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- Highlight on yank
local yankGrp = api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
	command = "silent! lua vim.highlight.on_yank()",
	group = yankGrp,
})

-- go to last loc when opening a buffer
api.nvim_create_autocmd(
	"BufReadPost",
	{ command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]] }
)

local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
api.nvim_create_autocmd(
	{ "InsertEnter", "WinLeave" },
	{ pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- Write file on focus lost
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
	pattern = "*",
	command = "wa",
})

vim.api.nvim_create_autocmd("User", {
	pattern = "LazyVimStarted",
	callback = function()
		local stats = require("lazy").stats()
		local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
		vim.notify("⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms")
	end,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	pattern = "*",
	callback = function()
		local opts = {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "always",
			prefix = " ",
			scope = "cursor",
		}
		vim.diagnostic.open_float(nil, opts)
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})
-- Autocommands END
