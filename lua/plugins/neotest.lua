return {
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "folke/neodev.nvim",
      optional = true,
      opts = function(_, opts)
        opts.library = opts.library or {}
        if opts.library.plugins ~= true then
          opts.library.plugins = utils.list_insert_unique(opts.library.plugins, { "neotest" })
        end
        opts.library.types = true
      end,
    },
  },
  specs = {
    {
      "catppuccin",
      optional = true,
      ---@type CatppuccinOptions
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
  config = function(_, opts)
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, vim.api.nvim_create_namespace("neotest"))
    require("neotest").setup(opts)
  end,
}
