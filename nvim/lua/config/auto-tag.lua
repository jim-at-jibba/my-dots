local status_ok, nvim_autotag = pcall(require, "nvim-ts-autotag")

if not status_ok then
    return
end

nvim_autotag.setup()