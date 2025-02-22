return {
  "neovim/nvim-lspconfig",
  opts = {
    ---@type lspconfig.options
    servers = {
      eslint = {
        settings = {
          workingDirectories = { mode = "auto" },
          codeActionOnSave = {
            enable = true,
            mode = "all",
          },
          format = true,
          rulesCustomizations = {},
          run = "onType",
          validate = "on",
          workingDirectory = { mode = "location" },
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
          primary = true,
          priority = 200,
          filter = "eslint",
        })

        -- Register the formatter with LazyVim
        require("lazyvim.util").format.register(formatter)

        -- Ensure ESLint fixes issues on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
          callback = function(args)
            local client = get_client(args.buf)
            if client then
              vim.lsp.buf.execute_command({
                command = "_eslint.applyAllFixes",
                arguments = { { uri = vim.uri_from_bufnr(args.buf) } },
              })
            end
          end,
        })
      end,
    },
  },
}
