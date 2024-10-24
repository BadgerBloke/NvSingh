return {
  {
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup({
        global_settings = {
          -- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
          save_on_toggle = false,

          -- saves the harpoon file on every change, disabling is not recommended.
          save_on_change = true,

          -- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
          enter_on_sendcmd = false,

          -- closes any tmux windows which are opened by harpoon when exiting neovim.
          tmux_autoclose_windows = false,

          -- filetypes that should be excluded from the harpoon list menu.
          excluded_filetypes = { "harpoon" },

          -- set marks specific to each git branch inside git repositories.
          -- Each branch will have its own set of mark files.
          mark_branch = true,

          -- enable tabline with harpoon marks.
          tabline = false,
          tabline_prefix = "  ",
          tabline_suffix = "  ",
        },
      })
      require("telescope").load_extension("harpoon")
    end,
  },
}
