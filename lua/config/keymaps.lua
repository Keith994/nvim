-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local del = vim.keymap.del

del("n", ";")
map("n", ";", ":", { desc = "Open ComandLine", remap = true })

del("n", "<S-h>")
del("n", "<S-l>")
map("n", "<S-h>", "0", { desc = "line head", remap = true })
map("n", "<S-l>", "$", { desc = "line tail", remap = true })
map("n", "<S-j>", "<cmd>bprevious<cr>", { desc = "Prev Buffer", remap = true })
map("n", "<S-k>", "<cmd>bnext<cr>", { desc = "Next Buffer", remap = true })

--local leader
-- stylua: ignore
map({ "n", "v" }, "<localleader>f", function() LazyVim.format({ force = true }) end, { desc = "Format" })
-- stylua: ignore
map("n", "<localleader>c", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window", silent=true })
map("n", "<localleader>p", function()
  local str = vim.fn.expand("%:p:f")
  vim.fn.setreg("+", str)
  print("当前文件路径：" .. str)
end, { desc = "Current Path" })

-- insert
map("i", "<c-a>", "<ESC>^i")
map("i", "<c-e>", "<End>")
map("i", "<c-l>", "<right>")
map("i", "<c-h>", "<left>")
map("i", "<S-Tab>", "<c-d>")

-- command line
map("c", "<c-a>", "<HOME>")
map("c", "<c-e>", "<End>")
map("c", "<c-f>", "<right>")
map("c", "<c-b>", "<left>")
map("c", "<c-h>", "<bs>")
map("c", "<c-d>", "<del>")
map("c", "<c-t>", [[<C-R>=expand("%:p:h") . "/" <CR>]])

--buffer
map("n", "<leader>bb", function() require("snacks").picker.buffers() end, { desc = "Find Buffer" })
map("n", "<leader>bd", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
del("n", "<leader>bD")
map("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit All" })
del("n", "t")
