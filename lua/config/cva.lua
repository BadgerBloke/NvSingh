local M = {}

M.setup = function()
  require("lspconfig").tailwindcss.setup({
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
            { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
          },
        },
      },
    },
  })
end

return M
