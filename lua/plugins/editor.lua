return {
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require "grug-far"
          local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
          grug.open {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          }
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
  {
    "OXY2DEV/helpview.nvim",
    lazy = false,
    opts = {
      preview = {
        icon_provider = "mini", -- "mini" or "devicons"
      },
    },
  },
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
      mappings = {
        ["`"] = false,
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    lazy = false,
    cmd = nil,
  },
  {
    "folke/which-key.nvim",
    opts = {

    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    enabled = true,
    opts = {
      preset = "helix",
      defaults = {},
      icons = {
        separator = "",
      },
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>c", group = "code" },
          { "<leader>s", group = "search" },
          { "<leader>q", group = "quit/session" },
          { "<leader>d", group = "debug" },
          { "<leader>dp", group = "profiler" },
          { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
          {
            "<leader>w",
            group = "windows",
            icon = { icon = " ", color = "blue" },
            proxy = "<c-w>",
            expand = function() return require("which-key.extras").expand.win() end,
          },
          -- better descriptions
          { "gx", desc = "Open with system app" },
        },
      },
    },
    keys = {
      "<leader>",
      {
        "<leader>?",
        function() require("which-key").show { global = false } end,
        desc = "Buffer Keymaps (which-key)",
      },
      {
        "<c-w><space>",
        function() require("which-key").show { keys = "<c-w>", loop = true } end,
        desc = "Window Hydra Mode (which-key)",
      },
    },
    config = function(_, opts)
      local wk = require "which-key"
      wk.setup(opts)
      if not vim.tbl_isempty(opts.defaults) then wk.register(opts.defaults) end
    end,
  },
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    specs = {
      "nvim-neo-tree/neo-tree.nvim",
      enabled = false,
    },
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>e",
        "<cmd>Yazi cwd<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>o",
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      -- {
      --   -- Open in the current working directory
      --   "<leader>cw",
      --   "<cmd>Yazi cwd<cr>",
      --   desc = "Open the file manager in nvim's working directory",
      -- },
      -- {
      --   -- NOTE: this requires a version of yazi that includes
      --   -- https://github.com/sxyazi/yazi/pull/1305 from 2024-07-18
      --   "<c-up>",
      --   "<cmd>Yazi toggle<cr>",
      --   desc = "Resume the last yazi session",
      -- },
    },
    ---@type YaziConfig
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {
        show_help = "<F25>",
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = {
      { "AstroNvim/astroui", opts = { icons = { Trouble = "󱍼" } } },
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local prefix = "<Leader>x"
          maps.n[prefix] = { desc = require("astroui").get_icon("Trouble", 1, true) .. "Trouble" }
          maps.n[prefix .. "X"] = { "<Cmd>Trouble diagnostics toggle<CR>", desc = "Workspace Diagnostics (Trouble)" }
          maps.n[prefix .. "x"] =
            { "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Document Diagnostics (Trouble)" }
          maps.n[prefix .. "l"] = { "<Cmd>Trouble loclist toggle<CR>", desc = "Location List (Trouble)" }
          maps.n[prefix .. "q"] = { "<Cmd>Trouble quickfix toggle<CR>", desc = "Quickfix List (Trouble)" }
          if require("astrocore").is_available "todo-comments.nvim" then
            maps.n[prefix .. "t"] = {
              "<cmd>Trouble todo<cr>",
              desc = "Todo (Trouble)",
            }
            maps.n[prefix .. "T"] = {
              "<cmd>Trouble todo filter={tag={TODO,FIX,FIXME}}<cr>",
              desc = "Todo/Fix/Fixme (Trouble)",
            }
          end
        end,
      },
    },
    opts = function()
      local get_icon = require("astroui").get_icon
      local lspkind_avail, lspkind = pcall(require, "lspkind")
      return {
        auto_refresh = false,
        keys = {
          ["<ESC>"] = "close",
          ["q"] = "close",
          ["<C-E>"] = "close",
        },
        icons = {
          indent = {
            fold_open = get_icon "FoldOpened",
            fold_closed = get_icon "FoldClosed",
          },
          folder_closed = get_icon "FolderClosed",
          folder_open = get_icon "FolderOpen",
          kinds = lspkind_avail and lspkind.symbol_map,
        },
      }
    end,
  },
  { "lewis6991/gitsigns.nvim", opts = { trouble = true } },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      if not opts.bottom then opts.bottom = {} end
      table.insert(opts.bottom, "Trouble")
    end,
  },
  {
    "catppuccin",
    optional = true,
    ---@type CatppuccinOptions
    opts = { integrations = { lsp_trouble = true } },
  },
}
