return {
  {
    "MKSinghDev/diagnostic-float.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {
      enabled = false,
      delay = 2000,
      toggle_key = "<C-i>",
      leader_command = "xd",
    },
    keys = {
      {
        "<C-i>",
        function()
          require("diagnostic-float").show_diagnostic_float()
        end,
        desc = "Show diagnostic",
      },
      {
        "<leader>xd",
        function()
          require("diagnostic-float").toggle()
        end,
        desc = "Toggle diagnostic",
      },
    },
  },
}
