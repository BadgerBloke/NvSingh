return {
  -- Enhanced Elixir LSP configuration (extends LazyVim's elixir extra)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        elixirls = {
          keys = {
            -- Pipe operator keymaps (LazyVim default)
            { "<leader>cp", false }, -- Disable default since we want custom implementation
            { "<leader>cP", false }, -- Disable default since we want custom implementation
          },
          settings = {
            elixirLS = {
              -- Enable dialyzer for type checking (can be slow on large projects)
              dialyzerEnabled = false, -- Set to true if you want type checking
              -- Enable formatting
              enableTestLenses = true,
              -- Suggest @spec annotations
              suggestSpecs = true,
              -- Auto-insert required alias/import/use statements
              autoInsertRequiredAlias = true,
              -- Signature help
              signatureAfterComplete = true,
            },
          },
        },
      },
    },
  },

  -- Auto-format on save for Elixir files
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        elixir = { "mix" },
        eelixir = { "mix" },
        heex = { "mix" },
      },
    },
  },

  -- Phoenix-specific keymaps and Mix commands
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Add keymaps when Elixir files are opened
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "elixir",
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          local opts = { buffer = buf, noremap = true, silent = true }

          -- Mix commands
          vim.keymap.set("n", "<leader>mc", function()
            vim.cmd("terminal mix compile")
          end, vim.tbl_extend("force", opts, { desc = "Mix compile" }))

          vim.keymap.set("n", "<leader>mt", function()
            vim.cmd("terminal mix test")
          end, vim.tbl_extend("force", opts, { desc = "Mix test (all)" }))

          vim.keymap.set("n", "<leader>md", function()
            vim.cmd("terminal mix deps.get")
          end, vim.tbl_extend("force", opts, { desc = "Mix deps.get" }))

          vim.keymap.set("n", "<leader>ms", function()
            vim.cmd("terminal iex -S mix phx.server")
          end, vim.tbl_extend("force", opts, { desc = "Start Phoenix server" }))

          -- IEx console
          vim.keymap.set("n", "<leader>mi", function()
            vim.cmd("terminal iex -S mix")
          end, vim.tbl_extend("force", opts, { desc = "Start IEx console" }))
        end,
      })
    end,
  },

  -- Enhanced testing with neotest-elixir
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "jfpedroza/neotest-elixir",
    },
    opts = {
      adapters = {
        ["neotest-elixir"] = {
          -- Default to running tests in interactive mode
          args = { "--trace" },
        },
      },
    },
  },
}
