local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

-- Define Python snippets
return {
  -- "for" snippet with choices
  s("for", {
    t("for "), c(1, {
      t("i in range("),  -- First choice
      t("x in xs"),      -- Second choice
      t("key, value in dict.items()")  -- Third choice
    }), t("):"), i(0),
  }),

  -- "for2" snippet (another option for the 'for' prefix)
  s("for2", {
    t("for "), i(1, "key"), t(" in "), i(2, "iterable"), t({":", "\t"}), i(0)
  }),
}

