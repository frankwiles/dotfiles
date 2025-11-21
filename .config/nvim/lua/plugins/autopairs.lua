return {
  -- Disable mini.pairs
  { "echasnovski/mini.pairs", enabled = false },

  -- Add nvim-autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      disable_in_macro = false,
      disable_in_visualblock = false,
      disable_in_replace_mode = true,
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright = true,
      enable_afterquote = true,
      enable_check_bracket_line = true,
      enable_bracket_in_quote = true,
      enable_abbr = false,
      break_undo = true,
      check_comma = true,
      map_char = {
        all = "(",
        tex = "{",
      },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)

      -- Setup for specific languages
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      -- Python-specific rules
      npairs.add_rules({
        -- F-strings
        Rule("f'", "'", "python")
          :with_pair(cond.not_after_regex("%w"))
          :with_pair(cond.not_before_regex("[%w%'%\"]", 1)),
        Rule('f"', '"', "python")
          :with_pair(cond.not_after_regex("%w"))
          :with_pair(cond.not_before_regex("[%w%'%\"]", 1)),
        -- Raw strings
        Rule("r'", "'", "python")
          :with_pair(cond.not_after_regex("%w"))
          :with_pair(cond.not_before_regex("[%w%'%\"]", 1)),
        Rule('r"', '"', "python")
          :with_pair(cond.not_after_regex("%w"))
          :with_pair(cond.not_before_regex("[%w%'%\"]", 1)),
      })

      -- JavaScript/React/TypeScript rules
      npairs.add_rules({
        Rule("`", "`", { "javascript", "typescript", "javascriptreact", "typescriptreact" }),
        Rule("${", "}", { "javascript", "typescript", "javascriptreact", "typescriptreact" })
          :with_pair(cond.before_regex("`"))
          :with_move(cond.none()),
      })

      -- Rust-specific rules
      npairs.add_rules({
        Rule("|", "|", "rust"):with_pair(cond.before_regex("%a")),
        Rule("'", "'", "rust"):with_pair(cond.not_before_regex("%w")),
      })

      -- Markdown rules (disable some autopairs in code blocks)
      npairs.add_rules({
        Rule("```", "```", "markdown"),
      })

      -- Integration with cmp if available
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if cmp_status_ok then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end

      -- Integration with blink.cmp if available
      local blink_status_ok, blink = pcall(require, "blink.cmp")
      if blink_status_ok then
        blink.setup({
          completion = {
            accept = {
              auto_brackets = {
                enabled = true,
              },
            },
          },
        })
      end
    end,
  },
}