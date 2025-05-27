return {
  {
    "mrcjkb/rustaceanvim",
    -- version = "^5", -- Recommended
    lazy = false, -- This plugin is already lazy
    ft = "rust",
    config = function()
      local mason_registry = require("mason-registry")
      local codelldb = mason_registry.get_package("codelldb")
      local extension_path = codelldb:get_install_path() .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"

      -- Cross-platform liblldb path detection
      local liblldb_path
      if vim.fn.has("mac") == 1 then
        liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
      elseif vim.fn.has("unix") == 1 then
        liblldb_path = extension_path .. "lldb/lib/liblldb.so"
      elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
        liblldb_path = extension_path .. "lldb/bin/liblldb.dll"
      else
        -- Fallback to Linux if platform detection fails
        liblldb_path = extension_path .. "lldb/lib/liblldb.so"
      end

      local cfg = require("rustaceanvim.config")
      vim.g.rustaceanvim = {
        dap = {
          adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      }
    end,
  },

  -- {
  --   "rust-lang/rust.vim",
  --   ft = "rust",
  --   init = function()
  --     vim.g.rustfmt_autosave = 1
  --   end,
  -- },

  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup({
        completion = {
          cmp = {
            enabled = true,
          },
        },
      })
      require("cmp").setup.buffer({
        sources = { { name = "crates" } },
      })
    end,
  },
}
