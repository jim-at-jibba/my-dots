local status_ok, trouble = pcall(require, "trouble")

if not status_ok then
	return
end

trouble.setup({
	auto_open = false,
	auto_close = true,
	auto_preview = true,
	use_lsp_diagnostic_signs = false,
})
