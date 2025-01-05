-- In lua/config/keymaps.lua
local map = vim.keymap.set

-- Better comment / uncomment
-- For visual mode (commenting selected blocks)
map("x", "/", "gc", { remap = true })
-- Normal mode for a single line
map("n", "/", "gcc", { remap = true })
