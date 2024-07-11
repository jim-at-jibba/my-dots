return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        -- Enable transparent background
        transparent = false,

        -- Enable italics comments
        italic_comments = true,

        -- Replace all fillchars with ' ' for the ultimate clean look
        hide_fillchars = false,

        -- Modern borderless telescope theme
        borderless_telescope = true,

        -- Set terminal colors used in `:terminal`
        terminal_colors = true,

        theme = {
          variant = "auto", -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
        },
      })
    end,
  },
}
