return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Explicitly disable pyright since we're using ty
        pyright = false,
        ruff = {
          init_options = {
            settings = {
              logLevel = "info",
              organizeImports = true,
              fixAll = true,
            },
          },
        },
      },
      setup = {
        -- Manually configure ty LSP since it's not in lspconfig yet
        ["*"] = function(server, opts)
          if server == "pyright" then
            -- Skip pyright setup entirely
            return true
          end
        end,
        ruff = function(_, opts)
          local lspconfig = require("lspconfig")
          lspconfig.ruff.setup(vim.tbl_deep_extend("force", opts, {
            on_attach = function(client, bufnr)
              -- Disable Ruff's hover capability to avoid conflicts with Pyright
              client.server_capabilities.hoverProvider = false

              -- Auto-organize imports on save
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.code_action({
                    context = { only = { "source.organizeImports" } },
                    apply = true,
                  })
                end,
              })
            end,
          }))
          return true
        end,
      },
    },
  },
  -- Manually setup ty LSP since it's not in lspconfig yet
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Setup ty LSP for Python files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function(args)
          local root_dir = vim.fs.root(args.buf, { "pyproject.toml", "setup.py", "setup.cfg", ".git" })
          if not root_dir then
            return
          end

          vim.lsp.start({
            name = "ty",
            cmd = { "ty", "server" },
            root_dir = root_dir,
            settings = {
              ty = {
                -- Diagnostic mode for type checking
                diagnosticMode = "openFilesOnly",
                -- Enable completions with auto-import
                completions = {
                  autoImport = true,
                },
                -- Enable inlay hints
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                  parameterTypes = true,
                  parameterNames = true,
                },
              },
            },
            on_attach = function(client, bufnr)
              -- Enable completion-based auto-imports
              client.server_capabilities.completionProvider = {
                resolveProvider = true,
                triggerCharacters = { ".", '"', "'", "`", "/", "@" },
              }

              -- Add keymaps specific to Python files
              local keymap_opts = { buffer = bufnr, noremap = true, silent = true }
              vim.keymap.set(
                "n",
                "<leader>ca",
                vim.lsp.buf.code_action,
                vim.tbl_extend("force", keymap_opts, { desc = "Code Actions" })
              )
            end,
          })
        end,
      })
    end,
  },
}

