return {
  "rest-nvim/rest.nvim",
  ft = "http",
  cmd = "Rest",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        if opts.ensure_installed ~= "all" then
          opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "http" })
        end
      end,
    },
  },
  specs = {
    {
      "AstroNvim/astroui",
      ---@type AstroUIOpts
      opts = { icons = { RestNvim = "󰳘" } },
    },
  },
  opts = {},
  config = function(_, opts)
    local utils = require "astrocore"
    opts = utils.extend_tbl({
      env = {
        pattern = "%.env",
      },
      response = {
        hooks = {
          decode_url = true,
          format = true,
        },
      },
    }, opts)
    vim.g.rest_nvim = require("astrocore").extend_tbl(opts, vim.g.rest_nvim)
  end,
}
