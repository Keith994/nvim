return {
  "nvimtools/none-ls.nvim",
  main = "null-ls",
  specs = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  dependencies = {
    {
      "jay-babu/mason-null-ls.nvim",
      dependencies = { "mason-org/mason.nvim" },
      cmd = { "NullLsInstall", "NullLsUninstall" },
      opts_extend = { "ensure_installed" },
      opts = { ensure_installed = {}, handlers = {} },
      config = function(_,opts)  
  if require("astrocore").is_available "mason-tool-installer.nvim" then opts.ensure_installed = nil end
  require("mason-null-ls").setup(opts)
      end,
    },
  },
  event = "User AstroFile",
  opts = function(_, opts) opts.on_attach = require("astrolsp").on_attach end,
}
