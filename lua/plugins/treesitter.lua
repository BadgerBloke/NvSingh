return {
  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "elixir",
          "eex",
          "tsx",
          "typescript",
          "heex",
          "bash",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        highlight = { enable = true },
        indent = { enable = true },
        modules = {},
      })
    end,
  },
}
