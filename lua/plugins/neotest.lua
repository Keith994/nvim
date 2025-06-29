-- stylua: ignore
local get_file_path = function() return vim.fn.expand("%") end
-- stylua: ignore
local get_project_path = function() return vim.fn.getcwd() end
local prefix = "t"
local watch_prefix = prefix .. "W"
return {
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
  },
  -- stylua: ignore
  keys = {
    { prefix, "", desc = "+test"},
    { prefix .. "t", function() require("neotest").run.run() end, desc = "Run test"},
    { prefix .. "r", function() require("neotest").run.run() end, desc = "Run test"},
    { prefix .. "d", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug test"},
    { prefix .. "f", function() require("neotest").run.run(get_file_path()) end, desc = "Run all tests in file"},
    { prefix .. "p", function() require("neotest").run.run(get_project_path()) end, desc = "Run all tests in project"},
    { prefix .. "<cr>", function() require("neotest").summary.toggle() end, desc = "Test Summary"},
    { prefix .. "O", function() require("neotest").output.open() end, desc = "Output hover"},
    { prefix .. "o", function() require("neotest").output_panel.toggle() end, desc = "Output window"},
    { "]T", function() require("neotest").jump.next() end, desc = "Next test"},
    { "[T", function() require("neotest").jump.prev() end, desc = "Previous test"},
    { watch_prefix , desc = "Watch Test"},
    { watch_prefix .. "t", function() require("neotest").watch.toggle() end, desc = "Toggle watch test"},
    { watch_prefix .. "f", function() require("neotest").watch.toggle(get_file_path()) end, desc = "Toggle watch all test in file"},
    { watch_prefix .. "p", function() require("neotest").watch.toggle(get_project_path()) end, desc = "Toggle watch all tests in project"},
    { watch_prefix .. "S", function() require("neotest").watch.stop() end, desc = "Stop all watches"},

  },
  specs = {
    {
      "catppuccin",
      optional = true,
      opts = { integrations = { neotest = true } },
    },
  },
  opts = function(_, opts)
    if vim.g.icons_enabled == false then
      opts.icons = {
        failed = "X",
        notify = "!",
        passed = "O",
        running = "*",
        skipped = "-",
        unknown = "?",
        watching = "W",
      }
    end
  end,
}
