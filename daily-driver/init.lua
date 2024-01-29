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

	-- editor plugins start

	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		config = function()
			require("mini.comment").setup({
				options = {
					custom_commentstring = function()
						return require("ts_context_commentstring.internal").calculate_commentstring()
							or vim.bo.commentstring
					end,
				},
			})
		end,
	},
	{
		"echasnovski/mini.pairs",
		version = "*",
		config = function()
			require("mini.pairs").setup()
		end,
	},
	{
		"echasnovski/mini.bufremove",
        -- stylua: ignore
        keys = {
            { "<leader>q", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
        },
	},
	{
		"echasnovski/mini.indentscope",
		version = false,
		config = function()
			require("mini.indentscope").setup()
		end,
	},
	{
		"PatschD/zippy.nvim",
		keys = {
			{ "<leader>l", "<cmd>lua require('zippy').insert_print()<CR>", desc = "Add debug log" },
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					-- default options: exact mode, multi window, all directions, with a backdrop
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "o", "x" },
				function()
					-- show labeled treesitter nodes around the cursor
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					-- jump to a remote location to execute the operator
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "n", "o", "x" },
				function()
					-- show labeled treesitter nodes around the search matches
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
		},
	},
	{
		"alexghergh/nvim-tmux-navigation",
		config = function()
			local nvim_tmux_nav = require("nvim-tmux-navigation")

			nvim_tmux_nav.setup({
				disable_when_zoomed = true, -- defaults to false
			})

			vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
			vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
			vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
			vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
			vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
			vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
		end,
	},
	-- telescope
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>b", ":Telescope buffers preview=true<CR>", desc = "View Buffers (Telescope)" },
			{ "<leader>lg", ":Telescope live_grep<CR>", desc = "Live grep (Telescope)" },
			{ "<leader>f", ":Telescope live_grep preview=true<CR>", desc = "Search (Telescope)" },
			{ "<leader>dr", ":Telescope lsp_references<CR>", desc = "LSP References (Telescope)" },
			{ "<C-p>", ":Telescope git_files preview=true<CR>", desc = "Fuzzy search (Telescope)" },
			{ "<leader>g", ":Telescope git_status preview=true<CR>", desc = "Git status (Telescope)" },
		},
		config = function()
			local trouble = require("trouble.providers.telescope")
			require("telescope").setup({
				defaults = {
					prompt_prefix = "🦄 ",
					color_devicons = true,
					selection_caret = " ",
					entry_prefix = "  ",
					initial_mode = "insert",
					selection_strategy = "reset",
					sorting_strategy = "descending",
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							prompt_position = "bottom",
							preview_width = 0.55,
							results_width = 0.8,
						},
						vertical = { mirror = false },
						width = 0.87,
						height = 0.80,
						preview_cutoff = 120,
					},
					winblend = 0,
					border = {},
					set_env = { ["COLORTERM"] = "truecolor" },
					file_sorter = require("telescope.sorters").get_fzy_sorter,
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					file_previewer = require("telescope.previewers").vim_buffer_cat.new,
					grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
					qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

					mappings = {
						i = {
							["<C-x>"] = false,
							["<C-q>"] = require("telescope.actions").send_to_qflist,
							["<c-t>"] = trouble.open_with_trouble,
							["<c-d>"] = require("telescope.actions").delete_buffer,
							["jk"] = require("telescope.actions").close,
						},
						n = {
							["<c-t>"] = trouble.open_with_trouble,
							["<c-d>"] = require("telescope.actions").delete_buffer,
							["jk"] = require("telescope.actions").close,
						},
					},
				},
				extensions = {
					fzf_native = {
						fuzzy = true,
						override_generic_sorter = false,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
					tldr = {
						-- your config here, see below for options
					},
				},
			})

			require("telescope").load_extension("fzf")
			require("telescope").load_extension("ui-select")
		end,
	},
	{ "nvim-telescope/telescope-ui-select.nvim" },
	{
		"folke/trouble.nvim",
		event = "VeryLazy",
		dependencies = "kyazdani42/nvim-web-devicons",
		cmd = { "TroubleToggle", "Trouble" },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
			{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
			{ "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
		},
		config = function()
			require("trouble").setup({
				auto_open = false,
				auto_close = true,
				auto_preview = true,
				use_lsp_diagnostic_signs = false,
			})
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			vim.keymap.set("n", "<leader><leader>1", ":Neotree toggle show filesystem right<CR>", { silent = true })
			vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", { silent = true })
		end,
	},
	-- editor plugins end
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
