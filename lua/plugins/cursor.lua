return {
  -- -- Smear cursor configuration
  -- {
  --   "sphamba/smear-cursor.nvim",
  --   event = "VeryLazy",
  --   cond = vim.g.neovide == nil,
  --   opts = {
  --     hide_target_hack = true,
  --     cursor_color = "none",
  --   },
  -- },
  --
  -- -- Disable mini.animate cursor
  -- {
  --   "echasnovski/mini.animate",
  --   optional = true,
  --   opts = {
  --     cursor = { enable = false },
  --   },
  -- },
  --
  -- -- Add additional cursor stability configurations
  -- {
  --   "LazyVim/LazyVim",
  --   opts = function()
  --     -- Disable cursor animations and blinking
  --     vim.opt.guicursor = {
  --       "n-v-c:block-Cursor/lCursor-blinkon0",
  --       "i-ci:ver25-Cursor/lCursor-blinkon0",
  --       "r:hor20-Cursor/lCursor-blinkon0",
  --     }
  --
  --     -- Optimize rendering
  --     vim.opt.updatetime = 300
  --     vim.opt.redrawtime = 1500
  --     vim.opt.lazyredraw = true
  --     vim.opt.ttyfast = true
  --
  --     -- Disable potentially problematic features
  --     vim.opt.cursorline = false
  --     vim.opt.cursorcolumn = false
  --     vim.opt.synmaxcol = 200
  --
  --     -- Disable various automatic features that might cause redraws
  --     vim.opt.wrapscan = false
  --     vim.opt.showcmd = false
  --     vim.opt.showmatch = false
  --
  --     -- Disable LSP document highlight
  --     local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
  --     vim.api.nvim_create_autocmd("LspAttach", {
  --       group = group,
  --       callback = function(args)
  --         local client = vim.lsp.get_client_by_id(args.data.client_id)
  --         if client and client.server_capabilities.documentHighlightProvider then
  --           client.server_capabilities.documentHighlightProvider = false
  --         end
  --       end,
  --     })
  --
  --     -- Complete TreeSitter configuration with all required fields
  --     require("nvim-treesitter.configs").setup({
  --       ensure_installed = {
  --         "lua",
  --         "vim",
  --         "vimdoc",
  --         "javascript",
  --         "typescript",
  --         "html",
  --         "css",
  --       },
  --       sync_install = false,
  --       auto_install = true,
  --       ignore_install = {},
  --       modules = {},
  --       highlight = {
  --         enable = true,
  --         additional_vim_regex_highlighting = false,
  --         -- Reduce the number of lines TreeSitter processes at once
  --         max_file_lines = 1000,
  --       },
  --       indent = {
  --         enable = true,
  --       },
  --       incremental_selection = {
  --         enable = false, -- Disable to reduce potential cursor issues
  --       },
  --     })
  --   end,
  -- },
}
