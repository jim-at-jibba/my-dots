return {
  {
    "Tsuzat/NeoSolarized.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local ok_status, NeoSolarized = pcall(require, "NeoSolarized")

      if not ok_status then
        return
      end

      -- Default Setting for NeoSolarized

      NeoSolarized.setup({
        style = "light", -- "dark" or "light"
        transparent = false,
      })
    end,
  },
}
