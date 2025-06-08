return {
  "axkirillov/unified.nvim",
  config = function()
    require("unified").setup({
      -- your configuration comes here
      vim.keymap.set(
        "n",
        "<leader>gu",
        ":Unified<CR>",
        { noremap = true, silent = true, desc = "Toggle Git Inline Diff" }
      ),
    })
  end,
}
