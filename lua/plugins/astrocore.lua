-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    autocmds = {
      astrolsp_createfiles_events = false,
      create_dir = false,
    },
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500 * 10, lines = 50000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true,                                      -- enable autopairs at start
      cmp = true,                                            -- enable completion at start
      diagnostics_mode = 3,                                  -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true,                                   -- highlight URLs at start
      notifications = true,                                  -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = false,
    },
    -- vim options can be configured here
    options = {
      opt = {                  -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true,         -- sets vim.opt.number
        spell = false,         -- sets vim.opt.spell
        signcolumn = "yes",    -- sets vim.opt.signcolumn to auto
        wrap = true,           -- sets vim.opt.wrap
        guifont = "LigaSFMonoNerdFont-Regular",
        showcmd = false,
        cmdheight = 1,
        expandtab = true,
        shiftwidth = 2,
        tabstop = 2,
        softtabstop = 2,
        timeoutlen = vim.g.vscode and 1000 or 300,
        winminwidth = 5, -- Minimum window width
      },
      g = {              -- vim.g.<key>
        snacks_animate = true,
        snacks_dim = true,
        -- configure global vim variables (vim.g)
        -- NOTE: `mapLeader` and `mapLocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map
        ["<Leader>w"] = { "󱂬 Windows", desc = nil },
        ["<Leader>x"] = { " Trouble", desc = nil },
        ["<LocalLeader>w"] = { "<cmd>w<cr>", desc = "Save" },
        ["<C-w>"] = { "<cmd>wq<cr>", desc = "Write and Quit Window" },
        ["<C-s>"] = { function() require("resession").save() end, desc = "Force Write And Save Session", },
        [";"] = { ":" },
        ["H"] = { "^" },
        ["L"] = { "$" },
        ["<LocalLeader>p"] = {
          function()
            local str = vim.fn.expand "%:p:f"
            vim.fn.setreg("+", str)
            print("当前文件路径：" .. str)
          end,
          desc = "Current Path",
        },
        ["<Leader><Enter>"] = { "<cmd>nohlsearch<cr>", desc = "No Highlight" },
        ["<Leader>uA"] = { "<cmd>Alpha<cr>", desc = "DashBoard" },
        ["<Leader>ws"] = { "<C-w>s", desc = "window split" },
        ["<Leader>wv"] = { "<C-w>v", desc = "window vsplit" },
        ["<Leader>w="] = { "<C-w>=", desc = "window balance" },                                                        -- mappings seen under group name "Buffer"
        ["<Leader>wh"] = { function() require("smart-splits").move_cursor_left() end, desc = "Move to left split" },   -- ["<Leader>bD"] = {
        ["<Leader>wj"] = { function() require("smart-splits").move_cursor_down() end, desc = "Move to below split" },  --   function()
        ["<Leader>wk"] = { function() require("smart-splits").move_cursor_up() end, desc = "Move to above split" },    --     require("astroui.status.heirline").buffer_picker(
        ["<Leader>wl"] = { function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" }, --       function(bufnr) require("astrocore.buffer").close(bufnr) end
        ["<Leader>gL"] = { "<cmd>BlameToggle<cr>", desc = "View File Blame" },
        ["<Leader>gg"] = { function() require("snacks.lazygit").open() end, desc = "Open lazygit" },
        ["<Leader>ld"] = { "<cmd>TodoTrouble<cr>", desc = "Todo List" },
        ["<Leader>fR"] = { function() require("spectre").open_visual() end, desc = "Find and replace" },
        ["<Leader>dL"] = {
          function()
            require("dap").list_breakpoints()
            vim.cmd "Trouble quickfix"
          end,
          desc = "list breakpoints",
        },
        ["<LocalLeader>c"] = { function() require("astrocore.buffer").close(0) end, desc = "Close buffer", },
        ["<LocalLeader>C"] = { function() require("astrocore.buffer").close(0, true) end, desc = "Force close buffer", },
        ["<Leader>bb"] = { function() require("snacks").picker.buffers() end, desc = "Find buffers", },
        ["<Leader>fa"] = { function() require("snacks").picker.autocmds() end, desc = "Find autocmd", },
        ["<Leader>fb"] = { function() require("snacks").picker.grep_buffers() end, desc = "Grep Open Buffers", },
        ["<Leader>fi"] = { function() require("snacks").picker.icons() end, desc = "Find icons", },
        ["K"] = { function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer", },
        ["J"] = { function() require("astrocore.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end, desc = "Previous buffer", },
        [">b"] = { function() require("astrocore.buffer").move(vim.v.count > 0 and vim.v.count or 1) end, desc = "Move buffer tab right", },
        ["<b"] = { function() require("astrocore.buffer").move(-(vim.v.count > 0 and vim.v.count or 1)) end, desc = "Move buffer tab left", },
        ["<A-j>"] = { "<cmd>m .+1<cr>==", desc = "Move down" },
        ["<A-k>"] = { "<cmd>m .-2<cr>==", desc = "Move up" },
        ["n"] = { "'Nn'[v:searchforward]", expr = true, desc = "Next search result" },
        ["N"] = { "'nN'[v:searchforward]", expr = true, desc = "Prev search result" },
        ["[q"] = { vim.cmd.cprev, desc = "Previous quickfix" },
        ["]q"] = { vim.cmd.cnext, desc = "Next quickfix" },
      },
      t = {
        ["<C-q>"] = { "<C-\\><C-n>:q<cr>", desc = "Close terminal" },
        ["<c-g>"] = { "<C-\\><C-n>:q<cr>" },
        -- setting a mapping to false will disable it
        -- ["<esc>"] = { "<C-\\><C-n>", desc = "Return normal" },
      },
      i = {
        ["<c-g>"] = { "<ESC>" },
        ["<c-a>"] = { "<ESC>^i" },
        ["<c-e>"] = { "<End>" },
        ["<c-l>"] = { "<right>" },
        ["<c-h>"] = { "<left>" },
        ["<c-n>"] = { "<down>" },
        ["<c-p>"] = { "<up>" },
        ["<A-j>"] = { "<esc><cmd>m .+1<cr>==gi", desc = "Move down" },
        ["<A-k>"] = { "<esc><cmd>m .-2<cr>==gi", desc = "Move up" },
        ["<S-Tab>"] = { "<C-d>", desc = "backward" }
      },
      x = {
        ["n"] = { "'Nn'[v:searchforward]", expr = true, desc = "Next search result" },
        ["N"] = { "'nN'[v:searchforward]", expr = true, desc = "Prev search result" },
      },
      o = {
        ["n"] = { "'Nn'[v:searchforward]", expr = true, desc = "Next search result" },
        ["N"] = { "'nN'[v:searchforward]", expr = true, desc = "Prev search result" },
      },
      v = {
        ["<A-j>"] = { ":m '>+1<cr>gv==gv", desc = "Move down" },
        ["<A-k>"] = { ":m '<-2<cr>gv==gv", desc = "Move up" },
      },
      c = {
        ["<c-a>"] = { "<Home>" },
        ["<c-e>"] = { "<End>" },
        ["<c-f>"] = { "<Right>" },
        ["<c-b>"] = { "<Left>" },
        ["<c-d>"] = { "<Del>" },
        ["<c-h>"] = { "<BS>" },
        ["<c-t>"] = { [[<C-R>=expand("%:p:h") . "/" <CR>]] },
      },
    },
  },
}
