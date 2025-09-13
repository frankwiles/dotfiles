# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a LazyVim-based Neovim configuration that extends the LazyVim starter template. The configuration is structured as follows:

- **init.lua**: Main entry point that bootstraps lazy.nvim, loads the config, and includes custom commands and LSP setup
- **lua/config/**: Core LazyVim configuration files (lazy.lua, keymaps.lua, options.lua, autocmds.lua)
- **lua/plugins/**: Custom plugin configurations that extend or override LazyVim defaults
- **lazy-lock.json**: Plugin lockfile managed by lazy.nvim
- **lazyvim.json**: LazyVim configuration with enabled extras

## Key Components

### Plugin Management
- Uses lazy.nvim as the plugin manager
- LazyVim provides the base plugin configuration
- Custom plugins are defined in `lua/plugins/*.lua` files
- Plugin versions are locked via `lazy-lock.json`

### LSP & Development Tools
- Mason manages LSP servers, linters, and formatters
- Auto-installs: stylua, pyright, ruff, typescript-language-server, tailwindcss-language-server, etc.
- Ruff LSP is specifically configured for Python development
- StyLua is configured for Lua formatting (2 spaces, 120 column width)

### Custom Features
- **TwColor command**: Replace Tailwind CSS color classes (`TwColor old-color new-color`)
- **SearchReplace command**: Global find/replace functionality
- **Custom keymaps**: Enhanced file navigation, TODO finding, JSON formatting
- **File path utilities**: Copy relative/full paths to clipboard with `<leader>fp`

## Common Development Commands

### Formatting
```bash
# Format Lua files with StyLua
stylua lua/
```

### Plugin Management
- `:Lazy` - Open lazy.nvim interface
- `:Lazy update` - Update plugins
- `:Lazy sync` - Sync plugins with lockfile

### Mason (LSP/Tools)
- `:Mason` - Open Mason interface
- Tools are auto-installed on startup per mason.lua configuration

## Custom Keymaps

Key mappings are defined in `lua/config/keymaps.lua`:
- `<leader>ft` - Find TODOs and annotations
- `<leader>fp` - Copy file path (relative to git root) to clipboard
- `<leader>js` - Create JSON scratch buffer with clipboard content
- `<leader>ff` - Find files with fzf-lua
- `<leader>fg` - Ripgrep search with quickfix
- `"` - Comment/uncomment (visual and normal mode)

## Configuration Structure

When modifying this configuration:
- Add new plugins in `lua/plugins/` as separate files
- Follow LazyVim plugin configuration patterns
- Use lazy loading where appropriate
- Custom keymaps go in `lua/config/keymaps.lua`
- Global options in `lua/config/options.lua`

## LazyVim Extras

Currently enabled extras (in lazyvim.json):
- `lazyvim.plugins.extras.ai.tabnine` - AI completion with TabNine
