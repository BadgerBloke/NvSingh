return {
  {
    "sam4llis/nvim-tundra",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.tundra_biome = "arctic" -- 'arctic' or 'jungle'
      vim.opt.background = "dark"
      vim.cmd.colorscheme("tundra")
    end,
  },

  -- Tell LazyVim to use tundra as default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tundra",
    },
  },
}
-- return {
--   {
--     "catppuccin/nvim",
--     lazy = false,
--     name = "catppuccin",
--     priority = 1000,
--
--     config = function()
--       require("catppuccin").setup({
--         transparent_background = true,
--         auto_integrations = true,
--       })
--       vim.cmd.colorscheme("catppuccin")
--     end,
--   },
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "catppuccin",
--       -- colorscheme = "tokyonight-night",
--       -- colorscheme = "github_dark_tritanopia",
--       -- colorscheme = "kanso-zen",
--       -- colorscheme = "yorumi",
--     },
--   },
-- }

--   {
--     "projekt0n/github-nvim-theme",
--     name = "github-theme",
--     lazy = false, -- make sure we load this during startup if it is your main colorscheme
--     priority = 1000, -- make sure to load this before all the other start plugins
--     config = function()
--       require("github-theme").setup({})
--
--       -- vim.cmd("colorscheme github_dark")
--     end,
--   },
--
--   {
--     "webhooked/kanso.nvim",
--     lazy = false,
--     priority = 1000,
--   },
--
--   {
--     "yorumicolors/yorumi.nvim",
--     lazy = false,
--     priority = 1000,
--   },
--
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "catppuccin",
--       -- colorscheme = "tokyonight-night",
--       -- colorscheme = "github_dark_tritanopia",
--       -- colorscheme = "kanso-zen",
--       -- colorscheme = "yorumi",
--     },
--   },
-- }
