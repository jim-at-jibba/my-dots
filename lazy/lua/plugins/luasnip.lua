local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Function to get the current function name
local function get_function_name()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local current_node = ts_utils.get_node_at_cursor()

  while current_node do
    if current_node:type() == "function_declaration" or current_node:type() == "method_declaration" then
      return ts_utils.get_node_text(current_node:child(1))[1] or ""
    end
    current_node = current_node:parent()
  end

  return ""
end

-- Function to get the word under the cursor
local function get_word_under_cursor()
  return vim.fn.expand("<cword>")
end

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
      -- make this into a function
      -- s("log-object", {
      --   t("console.log('"),
      --   f(function()
      --     return get_function_name()
      --   end),
      --   t(":, "),
      --   f(function()
      --     return get_word_under_cursor()
      --   end),
      --   t("')"),
      -- }),
    }, {
      key = "all",
    }),
  },
}
