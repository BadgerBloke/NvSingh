return {
  "folke/noice.nvim",
  opts = {
    routes = {
      {
        -- Suppress "No information available" notifications from LSP hover
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      },
    },
  },
}
