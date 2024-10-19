return {
  -- Elixir config
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig.elixirls.setup({
        -- you need to specify the executable command mannualy for elixir-ls
        cmd = { "elixir-ls" },
        capabilities = capabilities,
        dialyzerEnabled = true,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- install different completion source
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        -- add different completion source
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
        -- using default mapping preset
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        snippet = {
          -- you must specify a snippet engine
          expand = function(args)
            -- using neovim v0.10 native snippet feature
            -- you can also use other snippet engines
            vim.snippet.expand(args.body)
          end,
        },
      })
    end,
  },
}
