local map = vim.keymap.set
local del = vim.keymap.del

map("i", "<C-f>", "<Right>", { desc = "Move cursor forward" })
map("i", "<C-b>", "<Left>", { desc = "Move cursor backward" })
map("i", "<C-n>", "<Down>", { desc = "Move cursor down" })
map("i", "<C-p>", "<Up>", { desc = "Move cursor up" })
map("i", "<c-a>", "<ESC>^i", { desc = "Move to beginning of line" })
map("i", "<c-e>", "<End>", { desc = "Move to end of line" })
map("i", "<C-d>", "<Del>", { desc = "Delete character under cursor" })
map("i", "<C-h>", "<BS>", { desc = "Delete character before cursor" })
map("i", "<C-k>", "<C-o>D", { desc = "Delete to end of line" })
map("i", "<C-y>", "<C-r>+", { desc = "Paste from clipboard" })
map("i", "<C-/>", "<C-o>u", { desc = "Undo" })
map("i", "<C-s>", function()
  vim.cmd("stopinsert")
  require("flash").jump()
end, { desc = "Flash" })

map("i", "<C-x>o", "<Esc><cmd>Yazi<cr>", { desc = "Undo" })
map("i", "<C-x>e", function()
  -- 退出编辑模式
  vim.cmd("stopinsert")
  require("snacks").explorer()
end, { desc = "Open Snacks Explorer" })

map("i", "<A-f>", "<Esc>ea", { desc = "Move cursor forward by word" })
map("i", "<A-b>", "<C-o>b", { desc = "Move cursor backward by word" })
map("i", "<A-d>", "<C-o>diw", { desc = "Delete word after cursor" })
map("i", "<A-Backspace>", "<C-o>db", { desc = "Delete word before cursor" })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
