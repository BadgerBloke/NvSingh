-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set

-- Nvim DAP
map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
  "n",
  "<Leader>dd",
  "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { desc = "Debugger set conditional breakpoint" }
)
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

-- rustaceanvim
map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })

-- Harpoon
map("n", "<Leader>hx", "<cmd>lua require'harpoon.mark'.add_file()<CR>", { desc = "Harpoon add file" })
map("n", "<Leader>hn", "<cmd>lua require'harpoon.ui'.nav_next()<CR>", { desc = "Harpoon nav next" })
map("n", "<Leader>hp", "<cmd>lua require'harpoon.ui'.nav_prev()<CR>", { desc = "Harpoon nav prev" })
map("n", "<Leader>hc", "<cmd>lua require'harpoon.ui'.clear_all()<CR>", { desc = "Harpoon clear all" })
map("n", "<Leader>hm", "<cmd>lua require'harpoon.ui'.toggle_quick_menu()<CR>", { desc = "Harpoon toggle quick menu" })

-- LSP
map(
  "n",
  "<leader>i",
  "<cmd>lua vim.diagnostic.open_float(nil, {focus=false, scope='cursor'})<CR>",
  { desc = "LSP Hover" }
)
