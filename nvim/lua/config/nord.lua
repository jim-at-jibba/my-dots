local status_ok, nord = pcall(require, "nord")

if not status_ok then
	return
end

nord.setup({
	transparent = true,
	terminal_colors = true,
	diff = { mode = "bg" },
	borders = true,
	errors = { mode = "bg" },
})
