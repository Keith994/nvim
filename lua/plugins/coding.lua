return {
  {
    "stevearc/conform.nvim",
    event = "User AstroFile",
    cmd = "ConformInfo",
    specs = {
      { "AstroNvim/astrolsp", optional = true, opts = { formatting = { disabled = true } } },
      { "jay-babu/mason-null-ls.nvim", optional = true, opts = { methods = { formatting = false } } },
    },
    dependencies = {
      { "williamboman/mason.nvim", optional = true },
      {
        "AstroNvim/astrocore",
        opts = {
          options = { opt = { formatexpr = "v:lua.require'conform'.formatexpr()" } },
          commands = {
            Format = {
              function(args)
                local range = nil
                if args.count ~= -1 then
                  local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                  range = {
                    start = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                  }
                end
                require("conform").format { async = true, range = range }
              end,
              desc = "Format buffer",
              range = true,
            },
          },
        },
      },
    },
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
        json = { "jq" },
        lua = { "stylua" },
        jsonc = { "jq" },
        java = { "google-java-format" },
        yaml = { "prettierd" },
        xml = { "xmlformatter" },
      },
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = false,
    },
  },
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
    },
    dependencies = { { "nvim-lua/plenary.nvim" } },
  },
  {
    "okuuva/auto-save.nvim",
    event = { "User AstroFile", "InsertEnter" },
    dependencies = {
      "AstroNvim/astrocore",
      opts = {
        autocmds = {
          autoformat_toggle = {
            -- Disable autoformat before saving
            {
              event = "User",
              desc = "Disable autoformat before saving",
              pattern = "AutoSaveWritePre",
              callback = function()
                -- Save global autoformat status
                vim.g.OLD_AUTOFORMAT = vim.g.autoformat
                vim.g.autoformat = false

                local old_autoformat_buffers = {}
                -- Disable all manually enabled buffers
                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                  if vim.b[bufnr].autoformat then
                    table.insert(old_autoformat_buffers, bufnr)
                    vim.b[bufnr].autoformat = false
                  end
                end

                vim.g.OLD_AUTOFORMAT_BUFFERS = old_autoformat_buffers
              end,
            },
            -- Re-enable autoformat after saving
            {
              event = "User",
              desc = "Re-enable autoformat after saving",
              pattern = "AutoSaveWritePost",
              callback = function()
                -- Restore global autoformat status
                vim.g.autoformat = vim.g.OLD_AUTOFORMAT
                -- Re-enable all manually enabled buffers
                for _, bufnr in ipairs(vim.g.OLD_AUTOFORMAT_BUFFERS or {}) do
                  vim.b[bufnr].autoformat = true
                end
              end,
            },
          },
        },
      },
    },
    opts = {},
  },
  {
    "tpope/vim-dadbod",
    specs = {
      {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
          "tpope/vim-dadbod",
          { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
        },
        cmd = {
          "DBUI",
          "DBUIToggle",
          "DBUIAddConnection",
          "DBUIFindBuffer",
        },
        init = function()
          vim.g.db_ui_use_nerd_fonts = 1
          vim.g.db_ui_save_location = "~/db_ui_queries"
          vim.g.db_ui_win_position = "right"
          -- vim.g.db_ui_disable_mappings = 1
          vim.g.db_ui_show_database_icon = 1
        end,
        specs = {
          {
            "AstroNvim/astrocore",
            opts = {
              options = {
                g = {
                  db_use_nerd_fonts = vim.g.icons_enabled and 1 or nil,
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "stevearc/aerial.nvim",
    enabled = false,
  },
  -- { "folke/neoconf.nvim", enabled = false, opts = {} },
  {
    "windwp/nvim-autopairs",
    enabled = false,
  },
}
