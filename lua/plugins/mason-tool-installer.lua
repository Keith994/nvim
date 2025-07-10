return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  cmd = {
    "MasonToolsInstall",
    "MasonToolsInstallSync",
    "MasonToolsUpdate",
    "MasonToolsUpdateSync",
    "MasonToolsClean",
  },
  dependencies = {
    "mason-org/mason.nvim",
  },
  init = function(plugin)
    require("astrocore").on_load("mason.nvim", plugin.name)
  end,
  opts_extend = { "ensure_installed" },
  opts = {
    ensure_installed = {},
    integrations = { ["mason-lspconfig"] = false, ["mason-null-ls"] = false, ["mason-nvim-dap"] = false },
  },
  config = function(_, opts)
    local mason_tool_installer = require("mason-tool-installer")
    mason_tool_installer.setup(opts)
    if opts.run_on_start ~= false then
      mason_tool_installer.run_on_start()
    end
  end,
}
