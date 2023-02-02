local status_ok, indent = pcall(require, "indent_blankline")

if not status_ok then
	return
end

indent.setup({
	char = "│",
	filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
	show_trailing_blankline_indent = false,
	show_current_context = false,
})
