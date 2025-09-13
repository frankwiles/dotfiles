return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          capabilities = {
            textDocument = {
              publishDiagnostics = {
                tagSupport = {
                  valueSet = { 2 },
                },
              },
            },
          },
          settings = {
            pyright = {
              -- Using Ruff's import organizer
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- Enable auto-import completions
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                -- Enable type checking
                typeCheckingMode = "basic",
                -- Include function signatures in completions
                completeFunctionCalls = true,
                -- Index common libraries for auto-import
                indexing = true,
                packageIndexDepths = {
                  [""] = 4,
                  ["django"] = 4,
                  ["datetime"] = 2,
                },
              },
            },
          },
        },
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
        pyright = function(_, opts)
          local lspconfig = require("lspconfig")
          lspconfig.pyright.setup(vim.tbl_deep_extend("force", opts, {
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
          }))
          return true
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
}

