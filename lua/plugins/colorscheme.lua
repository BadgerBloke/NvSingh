return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
        float = {
          transparent = true, -- enable transparent floating windows
          solid = true, -- use solid styling for floating windows, see |winborder|
        },
      })
    end,
  },

  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("github-theme").setup({})

      -- vim.cmd("colorscheme github_dark")
    end,
  },

  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "yorumicolors/yorumi.nvim",
    lazy = false,
    priority = 1000,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
      -- colorscheme = "tokyonight-night",
      -- colorscheme = "github_dark_tritanopia",
      -- colorscheme = "kanso-zen",
      -- colorscheme = "yorumi",
    },
  },
}
