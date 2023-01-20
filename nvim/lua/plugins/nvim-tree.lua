return {
  {
    "kyazdani42/nvim-tree.lua",
    keys = {
      {
        "<leader><leader>1",
        "<cmd>NvimTreeToggle<cr>",
        desc = "Toggle NvimTree",
      },
      {
        "<leader>r",
        "<cmd>NvimTreeRefresh<cr>",
        desc = "Refresh NvimTree",
      },
    },
    -- change some options
    opts = {
      view = {
        hide_root_folder = true,
        side = "right",
        width = 40,
      },
    },
  },
}
