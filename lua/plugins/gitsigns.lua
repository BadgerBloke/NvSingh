return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({ current_line_blame = true })

    vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>gh", ":Gitsigns reset_hunk<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>gb", ":Gitsigns blame_line<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>gd", ":Gitsigns diffthis<CR>", { noremap = true, silent = true })
  end,
}
