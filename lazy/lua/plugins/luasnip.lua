local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node

return {
  "L3MON4D3/LuaSnip",
  opts = {

    ls.add_snippets("all", {
      s("todo", {
        t("// TODO(JGB): "),
      }),
      s("note", {
        t("// NOTE(JGB): "),
      }),
      s("question", {
        t("// QUESTION(JGB): "),
      }),
      s("bug", {
        t("// BUG(JGB): "),
      }),
      s("fixme", {
        t("// FIXME(JGB): "),
      }),
    }, {
      key = "all",
    }),
  },
}
