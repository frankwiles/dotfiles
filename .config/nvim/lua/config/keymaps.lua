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

-- fzf remaps

-- Override file finding mappings
map("n", "<leader><space>", function()
  require("fzf-lua").files({
    cwd = vim.fn.getcwd(),
    cwd_only = false,
  })
end, { desc = "Find files from root" })

map("n", "<leader>ff", function()
  require("fzf-lua").files({
    cwd = vim.fn.getcwd(),
    cwd_only = false,
  })
end, { desc = "Find files" })

map("n", "<leader>fg", function()
  local search_term = vim.fn.input("Search: ")
  if search_term ~= "" then
    vim.o.grepprg = "rg --vimgrep --smart-case --hidden"
    vim.cmd("grep! " .. vim.fn.shellescape(search_term))
    vim.cmd("copen")
  end
end, { desc = "Ripgrep search" })

-- Buffer management
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "Create new empty buffer" })
map("n", "<leader>tt", "<cmd>enew | terminal<CR>i", { desc = "Open new terminal buffer" })
