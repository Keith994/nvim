local notify = require("notify")
notify.init()
return {
  { "folke/lazy.nvim", dir = vim.env.LAZY },
  {
    "AstroNvim/astrocore",
    dependencies = { "AstroNvim/astroui" },
    lazy = false,
    priority = 10000,
    opts = function(_, opts)
      require("config.options")
      local get_icon = require("astroui").get_icon
      return require("astrocore").extend_tbl(opts, {
        features = {
          large_buf = {
            enabled = function(bufnr)
              return require("astrocore.buffer").is_valid(bufnr)
            end,
            notify = true,
            size = 1.5 * 1024 * 1024,
            lines = 100000,
            line_length = 1000,
          },
          autopairs = true, -- enable autopairs at start
          cmp = true, -- enable completion at start
          diagnostics = true, -- enable diagnostics by default
          highlighturl = true, -- highlight URLs by default
          notifications = true, -- disable notifications
        },
        diagnostics = {
          virtual_text = false,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = get_icon("DiagnosticError"),
              [vim.diagnostic.severity.HINT] = get_icon("DiagnosticHint"),
              [vim.diagnostic.severity.WARN] = get_icon("DiagnosticWarn"),
              [vim.diagnostic.severity.INFO] = get_icon("DiagnosticInfo"),
            },
          },
          update_in_insert = false,
          underline = true,
          severity_sort = true,
          float = {
            focused = false,
            style = "minimal",
            border = "rounded",
            source = true,
            header = "",
            prefix = "",
          },
          jump = { float = true },
        },
        rooter = {
          enabled = true,
          detector = { "lsp", { ".git", "_darcs", ".hg", ".bzr", ".svn" }, { "lua", "MakeFile", "package.json" } },
          ignore = {
            servers = {},
            dirs = {},
          },
          autochdir = false,
          scope = "global",
          notify = false,
        },
        sessions = {
          autosave = { last = true, cwd = true },
          ignore = {
            dirs = {},
            filetypes = { "gitcommit", "gitrebase" },
            buftypes = {},
          },
        },
      } --[[@as AstroCoreOpts]])

    end,
  },
}
