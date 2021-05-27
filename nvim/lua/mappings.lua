local map = require "utils".map
local leader = "<space>"

map("n", leader .. "w", ":update<CR>")

map("n", "<UP>", ":lua require('lists').move('up')<CR>", {silent = true})
map("n", "<DOWN>", ":lua require('lists').move('down')<CR>", {silent = true})
map("n", "<LEFT>", ":lua require('lists').move('left')<CR>", {silent = true})
map("n", "<RIGHT>", ":lua require('lists').move('right')<CR>", {silent = true})
map(
    "n",
    leader .. "c",
    "<Plug>(qf_qf_toggle_stay):lua require('lists').change_active('Quickfix')<CR>",
    {noremap = false}
)
map(
    "n",
    leader .. "v",
    "<Plug>(qf_loc_toggle_stay):lua require('lists').change_active('Location')<CR>",
    {noremap = false, silent = true}
)
map("n", leader .. "b", ":lua require('lists').toggle_active()<CR>")
map("n", leader .. "a", ":lua require('lists').change_active('Quickfix')<CR>:Ack<space>")
