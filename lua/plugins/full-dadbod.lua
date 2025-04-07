return {
  "tpope/vim-dadbod",
  specs = {
    {
      "kristijanhusak/vim-dadbod-ui",
      dependencies = { "tpope/vim-dadbod", { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, },
      cmd = {
        "DBUI",
        "DBUIToggle",
        "DBUIAddConnection",
        "DBUIFindBuffer",
      },
      init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.dbs = require "plugins.dbs_url.dbs"
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
        {
          "kristijanhusak/vim-dadbod-completion",
          lazy = true,
          specs = {
            {
              "saghen/blink.cmp",
              opts = {
                sources = {
                  per_filetype = {
                    sql = { "snippets", "dadbod", "buffer" },
                  },
                  -- add vim-dadbod-completion to your completion providers
                  providers = {
                    dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
                  },
                },
              },
            },
          },
        },
      },
    },
  },
}
