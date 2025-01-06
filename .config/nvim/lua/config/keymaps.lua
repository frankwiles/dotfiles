-- In lua/config/keymaps.lua
local map = vim.keymap.set

-- Indenting
map("v", ">", ">gv")
map("v", "<", "<gv")

map("n", ">", ">gv")
map("n", "<", "<gv")

-- Better comment / uncomment
-- For visual mode (commenting selected blocks)
map("x", '"', "gc", { remap = true })
-- Normal mode for a single line
map("n", '"', "gcc", { remap = true })

-- Find TODOs and comment
map("n", "<leader>ft", function()
  require("fzf-lua").grep({
    search = "TODO|HACK|PERF|NOTE|FIX",
    no_esc = true,
  })
end, { desc = "Find TODOs and annotations" })

-- Find keymaps
map("n", "<leader>fk", "<cmd>FzfLua keymaps<CR>", { desc = "Search keymaps" })

-- Quick JSON view
-- Add this to your keymaps
map("n", "<leader>js", function()
  -- Create a new scratch buffer
  vim.cmd("new")
  -- Set it to JSON filetype
  vim.bo.filetype = "json"
  -- Set it as a scratch buffer
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false

  -- Paste from system clipboard
  vim.cmd('normal! "+p')
  -- Format it
  vim.cmd("%!jq .")
end, { desc = "New JSON scratch buffer" })
