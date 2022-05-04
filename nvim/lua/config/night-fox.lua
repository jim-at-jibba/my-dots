local status_ok, nightfox = pcall(require, "nightfox")

if not status_ok then
	return
end

nightfox.setup()

-- vim.cmd("set background=dark")
-- vim.cmd("colorscheme rose-pine")
