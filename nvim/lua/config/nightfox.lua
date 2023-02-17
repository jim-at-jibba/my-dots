local status_ok, nightfox = pcall(require, "nightfox")

if not status_ok then
	return
end

nightfox.setup({
	options = {
		transparent = true, -- Disable setting background
		terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
		dim_inactive = true, -- Non focused panes set to alternative background
	},
})
