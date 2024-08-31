return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<c-\\>", desc = "Toggle terminal" },
    },
    opts = {
      direction = "float",
      open_mapping = [[<c-\>]],
      shell = vim.o.shell,
    },
    config = true,
  },
}
