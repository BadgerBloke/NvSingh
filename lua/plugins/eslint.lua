return {
  "neovim/nvim-lspconfig",
  opts = {
    ---@type lspconfig.options
    servers = {
      eslint = {
        settings = {
          -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
          workingDirectories = { mode = "auto" },
          -- Enable auto fix on save
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
        local function get_client(buf)
          return require("lazyvim.util").lsp.get_clients({ name = "eslint", bufnr = buf })[1]
        end

        local formatter = require("lazyvim.util").lsp.formatter({
          name = "eslint: lsp",
          primary = true, -- Set to true to make it primary formatter
          priority = 200,
          filter = "eslint",
        })

        -- Register the formatter with LazyVim
        require("lazyvim.util").format.register(formatter)

        -- Add additional setup for import sorting
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
          callback = function(args)
            local client = get_client(args.buf)
            if client then
              vim.cmd("EslintFixAll")
            end
          end,
        })
      end,
    },
  },
}
