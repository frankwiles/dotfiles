return {
  "saghen/blink.cmp",
  optional = true,
  dependencies = { "tzachar/cmp-tabnine", "saghen/blink.compat", "codota/tabnine-nvim" },
  opts = {
    sources = {
      compat = { "cmp_tabnine" },
      providers = {
        cmp_tabnine = {
          kind = "TabNine",
          score_offset = 100,
          async = true,
        },
      },
    },
  },
}
