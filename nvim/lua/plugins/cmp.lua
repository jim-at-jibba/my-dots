return {

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
				formatting = {
					format = lspkind.cmp_format({
						with_text = true,
						maxwidth = 50,
						mode = "symbol",
					}),
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
}
