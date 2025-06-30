

-- stylua: ignore
local mappings = {
  i = {},c = {}, x = {},o = {},v = {}, t = {},
  n = {
    -- second key is the lefthand side of the map
    ["<Leader>w"] = { "󱂬 Windows", desc = nil },
    ["<Leader>x"] = { " Trouble", desc = nil },
    ["<Leader>gL"] = { "<cmd>BlameToggle<cr>", desc = "View File Blame" },
    ["<Leader>gg"] = { function() require("snacks.lazygit").open() end, desc = "Open lazygit" },
    ["<Leader>ld"] = { "<cmd>TodoTrouble<cr>", desc = "Todo List" },
    ["<Leader>dL"] = {
      function()
        require("dap").list_breakpoints()
        vim.cmd "Trouble quickfix"
      end,
      desc = "list breakpoints",
    },
    ["<LocalLeader>C"] = { function() require("astrocore.buffer").close(0, true) end, desc = "Force close buffer" },
    ["<Leader>fa"] = { function() require("snacks").picker.autocmds() end, desc = "Find autocmd" },
    ["<Leader>fb"] = { function() require("snacks").picker.grep_buffers() end, desc = "Grep Open Buffers" },
    ["<Leader>fi"] = { function() require("snacks").picker.icons() end, desc = "Find icons" },
    ["<Leader>fH"] = { function() require("snacks").picker.highlights() end, desc = "Find highlight group" },
    ["[q"] = { vim.cmd.cprev, desc = "Previous quickfix" },
    ["]q"] = { vim.cmd.cnext, desc = "Next quickfix" },
    ["<LocalLeader>p"] = {
      function()
        local str = vim.fn.expand "%:p:f"
        vim.fn.setreg("+", str)
        print("当前文件路径：" .. str)
      end,
      desc = "Current Path",
    },
  },
}

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
      large_buf = { enabled = false, notify = true, size = 1024 * 500, lines = 3000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = false,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to auto
        wrap = true, -- sets vim.opt.wrap
        showcmd = false,
        cmdheight = 1,
        expandtab = true,
        shiftwidth = 2,
        tabstop = 2,
        softtabstop = 2,
        timeoutlen = vim.g.vscode and 1000 or 300,
        winminwidth = 5, -- Minimum window width
      },
      g = { -- vim.g.<key>
        snacks_indent = true,
        -- configure global vim variables (vim.g)
        -- NOTE: `mapLeader` and `mapLocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    mappings = mappings,
  },
}
