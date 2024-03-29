return {
	-- cmp
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
					-- format = lspkind.cmp_format({
					-- 	with_text = true,
					-- 	maxwidth = 50,
					-- 	mode = "symbol",
					-- }),
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

			-- snip_env = {
			-- 	s = require("luasnip.nodes.snippet").S,
			-- 	sn = require("luasnip.nodes.snippet").SN,
			-- 	t = require("luasnip.nodes.textNode").T,
			-- 	f = require("luasnip.nodes.functionNode").F,
			-- 	i = require("luasnip.nodes.insertNode").I,
			-- 	c = require("luasnip.nodes.choiceNode").C,
			-- 	d = require("luasnip.nodes.dynamicNode").D,
			-- 	r = require("luasnip.nodes.restoreNode").R,
			-- 	l = require("luasnip.extras").lambda,
			-- 	rep = require("luasnip.extras").rep,
			-- 	p = require("luasnip.extras").partial,
			-- 	m = require("luasnip.extras").match,
			-- 	n = require("luasnip.extras").nonempty,
			-- 	dl = require("luasnip.extras").dynamic_lambda,
			-- 	fmt = require("luasnip.extras.fmt").fmt,
			-- 	fmta = require("luasnip.extras.fmt").fmta,
			-- 	conds = require("luasnip.extras.expand_conditions"),
			-- 	types = require("luasnip.util.types"),
			-- 	events = require("luasnip.util.events"),
			-- 	parse = require("luasnip.util.parser").parse_snippet,
			-- 	ai = require("luasnip.nodes.absolute_indexer"),
			-- }
			--
			-- ls.config.set_config({ history = true, updateevents = "TextChanged,TextChangedI" })

			-- load friendly-snippets
			-- vsc.lazy_load({ paths = os.getenv("HOME") .. "/.config/nvim/snippets/"})
			vsc.lazy_load()
			-- load lua snippets
			-- lua.load({ paths = os.getenv("HOME") .. "/.config/nvim/snippets/" })

			-- expansion key
			-- this will expand the current item or jump to the next item within the snippet.
			vim.keymap.set({ "i", "s" }, "<c-j>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end, { silent = true })

			-- jump backwards key.
			-- this always moves to the previous item within the snippet
			vim.keymap.set({ "i", "s" }, "<c-k>", function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end, { silent = true })

			-- selecting within a list of options.
			vim.keymap.set("i", "<c-h>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end)
		end,
	},
}
