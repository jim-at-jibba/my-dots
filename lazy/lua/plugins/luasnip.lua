local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

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
      s("perf-start", {
        t("const startTime = performance.now();"),
      }),
      s("perf-end", {
        t("const endTime = performance.now();"),
        t("console.log('"),
        i(1, "perf name"),
        t("', endTime - startTime)"),
      }),
    }, {
      key = "all",
    }),
  },
}
