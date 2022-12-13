local status_ok, rose_pine = pcall(require, "rose-pine")

if not status_ok then
	return
end

rose_pine.setup({
	---@usage 'main'|'moon'
	dark_variant = "main",
	bold_vert_split = false,
	dim_nc_background = true,
	disable_background = true,
	disable_float_background = false,
	disable_italics = false,
	---@usage string hex value or named color from rosepinetheme.com/palette
	groups = {
		panel = "surface",
		border = "highlight_med",
		comment = "muted",
		link = "iris",
		punctuation = "subtle",

		error = "love",
		hint = "iris",
		info = "foam",
		warn = "gold",

		headings = {
			h1 = "iris",
			h2 = "foam",
			h3 = "rose",
			h4 = "gold",
			h5 = "pine",
			h6 = "foam",
		},
		-- or set all headings at once
		-- headings = 'subtle'
	},
	-- Change specific vim highlight groups
	highlight_groups = {
		ColorColumn = { bg = "rose" },
	},
})

-- vim.cmd("set background=light")
vim.cmd("colorscheme rose-pine")
