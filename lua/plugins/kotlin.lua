return {
  "AlexandrosAlexiou/kotlin.nvim",
  ft = { "kotlin" },
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "kotlin-lsp" })
      end,
    },
    {
      "mason-org/mason-lspconfig.nvim",
      opts = function(_, opts)
        -- Prevent auto-installation and setup of ALL kotlin LSP servers
        -- since kotlin.nvim manages its own language server via kotlin-lsp
        opts.automatic_installation = opts.automatic_installation or {}
        opts.automatic_installation.exclude = opts.automatic_installation.exclude or {}
        vim.list_extend(opts.automatic_installation.exclude, { "kotlin_language_server", "kotlin_lsp" })

        -- Add handlers to completely ignore both kotlin servers
        opts.handlers = opts.handlers or {}
        opts.handlers["kotlin_language_server"] = function() end
        opts.handlers["kotlin_lsp"] = function() end
      end,
    },
    {
      "folke/trouble.nvim",
      cmd = "Trouble",
      opts = {},
    },
  },
  init = function()
    -- Disable kotlin filetype detection for lspconfig BEFORE any LSP starts
    -- This prevents both kotlin_language_server and kotlin_lsp from auto-starting
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "kotlin",
      callback = function()
        -- Stop any duplicate kotlin LSP clients (keep only kotlin_ls from kotlin.nvim)
        for _, client in ipairs(vim.lsp.get_clients({ name = "kotlin_language_server" })) do
          vim.lsp.stop_client(client.id, true)
        end
        for _, client in ipairs(vim.lsp.get_clients({ name = "kotlin_lsp" })) do
          vim.lsp.stop_client(client.id, true)
        end
      end,
    })
  end,
  config = function()
    require("kotlin").setup({
      -- Root markers for project detection
      root_markers = {
        "gradlew",
        ".git",
        "mvnw",
        "settings.gradle",
      },

      -- Use SDKMAN-managed Java current for symbol resolution (analyzing your code)
      jdk_for_symbol_resolution = "/Users/mksingh/.sdkman/candidates/java/current",

      -- Use bundled JRE from Mason to run the kotlin-lsp server (recommended)
      jre_path = nil,

      -- Optional: Increase heap for large projects
      jvm_args = {
        "-Xmx4g",
      },

      -- Enable all inlay hints by default
      inlay_hints = {
        enabled = true,
        parameters = true,
        parameters_compiled = true,
        parameters_excluded = false,
        types_property = true,
        types_variable = true,
        function_return = true,
        function_parameter = true,
        lambda_return = true,
        lambda_receivers_parameters = true,
        value_ranges = true,
        kotlin_time = true,
      },
    })

    -- Keymaps with <leader>lk prefix
    vim.keymap.set("n", "<leader>lka", ":KotlinCodeActions<CR>", { desc = "Kotlin code actions" })
    vim.keymap.set("n", "<leader>lkq", ":KotlinQuickFix<CR>", { desc = "Kotlin quick fix" })
    vim.keymap.set("n", "<leader>lko", ":KotlinOrganizeImports<CR>", { desc = "Organize Kotlin imports" })
    vim.keymap.set("n", "<leader>lkf", ":KotlinFormat<CR>", { desc = "Format Kotlin buffer (LSP)" })
    vim.keymap.set("n", "<leader>lks", ":KotlinSymbols<CR>", { desc = "Show Kotlin document symbols" })
    vim.keymap.set("n", "<leader>lkw", ":KotlinWorkspaceSymbols<CR>", { desc = "Search workspace symbols" })
    vim.keymap.set("n", "<leader>lkr", ":KotlinReferences<CR>", { desc = "Find Kotlin references" })
    vim.keymap.set("n", "<leader>lkn", ":KotlinRename<CR>", { desc = "Rename Kotlin symbol" })
    vim.keymap.set("n", "<leader>lkh", ":KotlinInlayHintsToggle<CR>", { desc = "Toggle Kotlin inlay hints" })
    vim.keymap.set("n", "<leader>lkc", ":KotlinCleanWorkspace<CR>", { desc = "Clean Kotlin workspace" })
  end,
}
