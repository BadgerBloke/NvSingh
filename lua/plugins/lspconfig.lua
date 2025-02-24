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
    },
  },
}
