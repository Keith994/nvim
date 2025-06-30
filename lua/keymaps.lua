local map = vim.keymap.set
map("n", ";", ":")
map("n", "H", "0")
map("n", "L", "$")
-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- terminal
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- InsertMode Move
map("i", "<c-g>", "<ESC>")
map("i", "<c-a>", "<ESC>^i")
map("i", "<c-e>", "<End>")
map("i", "<c-l>", "<right>")
map("i", "<c-h>", "<left>")
map("i", "<c-n>", "<down>")
map("i", "<c-p>", "<up>")
map("i", "<S-Tab>", "<C-d>", { desc = "backward" })

-- Command Line Move
map("c", "<c-a>", "<Home>")
map("c", "<c-e>", "<End>")
map("c", "<c-f>", "<Right>")
map("c", "<c-b>", "<Left>")
map("c", "<c-d>", "<Del>")
map("c", "<c-h>", "<BS>")
map("c", "<c-t>", [[<C-R>=expand("%:p:h") . "/" <CR>]])

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-j>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move down" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- buffers
-- stylua: ignore
map("n", "<S-j>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-k>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<Leader>bb", function() require("snacks").picker.buffers() end, { desc = "Find Buffers" })
map("n", "<Leader>bd", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
map("n", "<Leader>bo", function() require("snacks").bufdelete.other() end, { desc = "Delete Other Buffers" })
-- stylua: ignore
map("n", ">b", function() require("astrocore.buffer").move(vim.v.count > 0 and vim.v.count or 1) end, {desc = "Move buffer tab right",})
-- stylua: ignore
map("n", "<b", function() require("astrocore.buffer").move(-(vim.v.count > 0 and vim.v.count or 1)) end, {desc = "Move buffer tab left",})

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
