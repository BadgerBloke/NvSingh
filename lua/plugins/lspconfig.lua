return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      eslint = {
        settings = {
          workingDirectories = { mode = "auto" },
          codeAction = {
            disableRuleComment = {
              enable = true,
              location = "separateLine",
            },
            showDocumentation = {
              enable = true,
            },
          },
          codeActionOnSave = {
            enable = true,
            mode = "all",
          },
          format = true,
          nodePath = "",
          onIgnoredFiles = "off",
          packageManager = "npm",
          quiet = false,
          rulesCustomizations = {},
          run = "onType",
          useESLintClass = false,
          validate = "on",
          workingDirectory = {
            mode = "location",
          },
        },
      },
      -- Add Deno LSP configuration
      denols = {
        root_dir = function(bufnr, on_dir)
          local root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
          if root then
            return on_dir(root)
          end
        end,
        single_file_support = false,
        settings = {},
      },
      -- Add TypeScript LSP configuration
      vtsls = {
        root_dir = function(bufnr, on_dir)
          local root = vim.fs.root(bufnr, { "package.json", "tsconfig.json", "jsconfig.json" })
          if root then
            return on_dir(root)
          end
        end,
        single_file_support = false,
        settings = {},
      },
      -- Completely disable both kotlin LSP servers (kotlin.nvim manages it)
      kotlin_language_server = {
        autostart = false,
        enabled = false,
        filetypes = {}, -- Remove kotlin filetype association
      },
      kotlin_lsp = {
        autostart = false,
        enabled = false,
        filetypes = {}, -- Remove kotlin filetype association
      },
    },
    setup = {
      -- Prevent both kotlin LSP servers from ever starting
      kotlin_language_server = function()
        return true
      end,
      kotlin_lsp = function()
        return true
      end,
      eslint = function()
        -- Explicitly disable formatters other than ESLint for JS/TS files
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          callback = function()
            -- Disable other formatters for these file types
            vim.b.formatting_disabled = true
            -- But allow ESLint formatting
            local client = (vim.lsp.get_clients and vim.lsp.get_clients({ name = "eslint", bufnr = 0 }) or {})[1]
            if client then
              vim.b.formatting_disabled = false
            end
          end,
        })
        -- Create more reliable autocmd for formatting on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
          callback = function()
            pcall(function()
              vim.cmd("LspEslintFixAll")
            end)
          end,
        })
      end,
      -- Add setup function for Deno
      denols = function()
        -- Define your on_attach function if needed or use existing one
        -- The actual setup is handled by the servers configuration above
      end,
      -- Add setup function for TypeScript
      vtsls = function()
        -- The actual setup is handled by the servers configuration above
      end,
    },
  },
}
