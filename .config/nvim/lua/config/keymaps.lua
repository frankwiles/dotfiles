-- In lua/config/keymaps.lua
local map = vim.keymap.set

-- Better comment / uncomment
-- For visual mode (commenting selected blocks)
map("x", "/", "gc", { remap = true })
-- Normal mode for a single line
map("n", "/", "gcc", { remap = true })

-- Find TODOs and comment
map("n", "<leader>ft",
  function()
    require('fzf-lua').grep({
      search = 'TODO|HACK|PERF|NOTE|FIX',
      no_esc = true
    })
  end,
  { desc = "Find TODOs and annotations" }
)
