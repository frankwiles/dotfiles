-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- require("lazy").setup({
--   { "codota/tabnine-nvim", build = "./dl_binaries.sh" },
-- })

-- require("tabnine").setup({
--   disable_auto_comment = true,
--   accept_keymap = "<Tab>",
--   dismiss_keymap = "<C-]>",
--   debounce_ms = 800,
--   suggestion_color = { gui = "#808080", cterm = 244 },
--   exclude_filetypes = { "TelescopePrompt", "NvimTree" },
--   log_file_path = nil, -- absolute path to Tabnine log file
--   ignore_certificate_errors = false,
-- })

-- In init.lua
local function tailwind_color_replace(from_color, to_color)
  -- Use a simpler pattern that works better with Lua string escaping
  local pattern = string.format("(bg|text|border|ring|shadow)-%s", vim.pesc(from_color))
  local replacement = string.format("\\1-%s", to_color)

  -- Use pcall to catch the error gracefully
  local success, err = pcall(function()
    vim.cmd(string.format("%%s/%s/%s/g", pattern, replacement))
  end)

  if not success then
    print(string.format("Pattern not found: %s", from_color))
  else
    print(string.format("Replaced %s with %s", from_color, to_color))
  end
end

vim.api.nvim_create_user_command("TwColor", function(opts)
  local args = vim.split(opts.args, " ")
  if #args == 2 then
    tailwind_color_replace(args[1], args[2])
  else
    print("Usage: TwColor <from_color> <to_color>")
  end
end, { nargs = "*" })

local function search_replace(from, to)
  -- Use pcall to catch the error gracefully
  local success, err = pcall(function()
    vim.cmd(string.format("%%s/%s/%s/g", from, to))
  end)

  if not success then
    print(string.format("Pattern not found: %s", from))
  else
    print(string.format("Replaced %s with %s", from, to))
  end
end

vim.api.nvim_create_user_command("SearchReplace", function(opts)
  local args = vim.split(opts.args, " ")
  if #args == 2 then
    search_replace(args[1], args[2])
  else
    print("Usage: SearchReplace <from_color> <to_color>")
  end
end, { nargs = "*" })
