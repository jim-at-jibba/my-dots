local status_ok, dap_virt = pcall(require, "nvim-dap-virtual-text")

if not status_ok then
	return
end

dap_virt.setup()
