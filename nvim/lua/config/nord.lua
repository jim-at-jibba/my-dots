local status_ok, nord = pcall(require, "nord")

if not status_ok then
	return
end

vim.g.nord_contrast = false
vim.g.nord_borders = true
vim.g.nord_disable_background = true
vim.g.nord_italic = true
vim.g.nord_uniform_diff_background = true
vim.g.nord_bold = true

nord.set()
