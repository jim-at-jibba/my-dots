local status_ok, nvim_gps = pcall(require, "pomodoro")

if not status_ok then
    return
end

nvim_gps.setup()