return {
  "neovim/nvim-lspconfig",
  opts = {
    ---@type lspconfig.options
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
        root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
        single_file_support = false,
        settings = {},
      },
      -- Add TypeScript LSP configuration
      vtsls = {
        root_dir = require("lspconfig").util.root_pattern({ "package.json", "tsconfig.json" }),
        single_file_support = false,
        settings = {},
      },
    },
    setup = {
      eslint = function()
        -- Explicitly disable formatters other than ESLint for JS/TS files
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          callback = function()
            -- Disable other formatters for these file types
            vim.b.formatting_disabled = true
            -- But allow ESLint formatting
            local client = require("lazyvim.util").lsp.get_clients({ name = "eslint", bufnr = 0 })[1]
            if client then
              vim.b.formatting_disabled = false
            end
          end,
        })
        -- Create a dedicated command for ESLint fixing
        vim.api.nvim_create_user_command("EslintFormat", function()
          local client = require("lazyvim.util").lsp.get_clients({ name = "eslint", bufnr = 0 })[1]
          if client then
            vim.cmd("EslintFixAll")
          end
        end, {})
        -- Create more reliable autocmd for formatting on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
          callback = function()
            pcall(function()
              vim.cmd("EslintFormat")
            end)
          end,
        })
      end,
      -- Add setup function for Deno
      denols = function()
        -- Define your on_attach function if needed or use existing one
        local on_attach = function(client, bufnr)
          -- Add your on_attach logic here if needed
        end

        -- The actual setup is handled by the servers configuration above
      end,
      -- Add setup function for TypeScript
      vtsls = function()
        -- The actual setup is handled by the servers configuration above
      end,
    },
  },
}
