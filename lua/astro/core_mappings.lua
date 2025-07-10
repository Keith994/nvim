return {
  {
    "AstroNvim/astrocore",
    opts = function()
      require("config.keymaps")
      local astro = require("astrocore")
      local maps = astro.empty_map_table()
      maps.n[">b"] = {
        function()
          require("astrocore.buffer").move(vim.v.count1)
        end,
        desc = "Move buffer tab right",
      }
      maps.n["<b"] = {
        function()
          require("astrocore.buffer").move(-vim.v.count1)
        end,
        desc = "Move buffer tab left",
      }
      maps.n["|"] = { "<Cmd>vsplit<CR>", desc = "Vertical Split" }
      maps.n["\\"] = { "<Cmd>split<CR>", desc = "Horizontal Split" }
      maps.n["gra"] = false
      maps.x["gra"] = false
      maps.n["grn"] = false
      maps.n["grr"] = false
      maps.n["gri"] = false
      maps.n["gO"] = false
      maps.i["<C-S>"] = false
      maps.s["<C-S>"] = false
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      preset = "helix",
      defaults = {},
      delay = 30,
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debug" },
          { "<leader>dp", group = "profiler" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git", icon = { icon = " ", color = "blue" } },
          { "<leader>gh", group = "hunks" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
          { "<leader>/", group = "search" },
          { "<leader>e", group = "explorer", icon = { icon = " " } },
          { "<leader>l", group = "lazy", icon = { icon = "󰒲 ", color = "green" } },
          { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
          {
            "<leader>b",
            group = "buffer",
          },
          {
            "<leader>w",
            group = "windows",
          },
          -- better descriptions
          { "gx", desc = "Open with system app" },
          {
            "<leader>t",
            group = "test",
            icon = { icon = "󰙨" },
          },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps (which-key)",
      },
      {
        "<c-w><space>",
        function()
          require("which-key").show({ keys = "<c-w>", loop = true })
        end,
        desc = "Window Hydra Mode (which-key)",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      if not vim.tbl_isempty(opts.defaults) then
        wk.add(opts.defaults)
      end
    end,
  },
}
