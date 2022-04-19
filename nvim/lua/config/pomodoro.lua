local status_ok, pomodoro = pcall(require, "pomodoro")

if not status_ok then
    return
end

pomodoro.setup({
    time_work = 25,
    time_break_short = 5,
    time_break_long = 20,
    timers_to_long_break = 4
})
