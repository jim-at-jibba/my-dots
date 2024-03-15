return {
  {
    "LunarLambda/todo-comments.nvim",
    branch = "enhanced-matching",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        pattern = {
          -- NOTE(xyz):
          [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
          -- TODO 123:
          [[.*<((KEYWORDS)%(\s+\d+)?):]],
        },
      },
    },
  },
}
