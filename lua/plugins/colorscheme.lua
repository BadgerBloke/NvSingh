return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    -- you can do it like this with a config function
    -- or just use opts table
    opts = function(_, opts)
      if (vim.g.colors_name or ""):find("catppuccin") then
        opts.highlights = require("catppuccin.groups.integrations.bufferline").get_theme()
      end
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
