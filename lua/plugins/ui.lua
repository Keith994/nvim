local pick = nil

pick = function()
  local fzf_lua = require("fzf-lua")
  local project = require("project_nvim.project")
  local history = require("project_nvim.utils.history")
  local results = history.get_recent_projects()
  local utils = require("fzf-lua.utils")

  local function hl_validate(hl)
    return not utils.is_hl_cleared(hl) and hl or nil
  end

  local function ansi_from_hl(hl, s)
    return utils.ansi_from_hl(hl_validate(hl), s)
  end

  local opts = {
    fzf_opts = {
      ["--header"] = string.format(
        ":: <%s> to %s | <%s> to %s | <%s> to %s | <%s> to %s | <%s> to %s",
        ansi_from_hl("FzfLuaHeaderBind", "ctrl-t"),
        ansi_from_hl("FzfLuaHeaderText", "tabedit"),
        ansi_from_hl("FzfLuaHeaderBind", "ctrl-s"),
        ansi_from_hl("FzfLuaHeaderText", "live_grep"),
        ansi_from_hl("FzfLuaHeaderBind", "ctrl-r"),
        ansi_from_hl("FzfLuaHeaderText", "oldfiles"),
        ansi_from_hl("FzfLuaHeaderBind", "ctrl-w"),
        ansi_from_hl("FzfLuaHeaderText", "change_dir"),
        ansi_from_hl("FzfLuaHeaderBind", "ctrl-d"),
        ansi_from_hl("FzfLuaHeaderText", "delete")
      ),
    },
    fzf_colors = true,
    actions = {
      ["default"] = {
        function(selected)
          fzf_lua.files({ cwd = selected[1] })
        end,
      },
      ["ctrl-t"] = {
        function(selected)
          vim.cmd("tabedit")
          fzf_lua.files({ cwd = selected[1] })
        end,
      },
      ["ctrl-s"] = {
        function(selected)
          fzf_lua.live_grep({ cwd = selected[1] })
        end,
      },
      ["ctrl-r"] = {
        function(selected)
          fzf_lua.oldfiles({ cwd = selected[1] })
        end,
      },
      ["ctrl-w"] = {
        function(selected)
          local path = selected[1]
          local ok = project.set_pwd(path)
          if ok then
            vim.api.nvim_win_close(0, false)
            utils.info("Change project dir to " .. path)
          end
        end,
      },
      ["ctrl-d"] = function(selected)
        local path = selected[1]
        local choice = vim.fn.confirm("Delete '" .. path .. "' project? ", "&Yes\n&No")
        if choice == 1 then
          history.delete_project({ value = path })
        end
        pick()
      end,
    },
  }

  fzf_lua.fzf_exec(results, opts)
end

-- toggle options
require("snacks").toggle.option("spell", { name = "Spelling" }):map("<leader>us")
require("snacks").toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
require("snacks").toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
require("snacks").toggle.diagnostics():map("<leader>ud")
require("snacks").toggle.line_number():map("<leader>ul")
require("snacks").toggle
    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
    :map("<leader>uc")
require("snacks").toggle
    .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
    :map("<leader>uA")
require("snacks").toggle.treesitter():map("<leader>uT")
require("snacks").toggle
    .option("background", { off = "light", on = "dark", name = "Dark Background" })
    :map("<leader>ub")
require("snacks").toggle.dim():map("<leader>uD")
require("snacks").toggle.animate():map("<leader>ua")
require("snacks").toggle.indent():map("<leader>ug")
require("snacks").toggle.scroll():map("<leader>uS")
require("snacks").toggle.profiler():map("<leader>dpp")
require("snacks").toggle.profiler_highlights():map("<leader>dph")
require("snacks").toggle.inlay_hints():map("<leader>uh")

return {
  {
    "snacks.nvim",
    priority = 999,
    opts = {
      dashboard = {
        preset = {
          header = [[
                  ,--.              ,----..                                 ____
                ,--.'|    ,---,.   /   /   \                 ,---,        ,'  , `.
            ,--,:  : |  ,'  .' |  /   .     :        ,---.,`--.' |     ,-+-,.' _ |
          ,`--.'`|  ' :,---.'   | .   /   ;.  \      /__./||   :  :  ,-+-. ;   , ||
          |   :  :  | ||   |   .'.   ;   /  ` ; ,---.;  ; |:   |  ' ,--.'|'   |  ;|
          :   |   \ | ::   :  |-,;   |  ; \ ; |/___/ \  | ||   :  ||   |  ,', |  ':
          |   : '  '; |:   |  ;/||   :  | ; | '\   ;  \ ' |'   '  ;|   | /  | |  ||
          '   ' ;.    ;|   :   .'.   |  ' ' ' : \   \  \: ||   |  |'   | :  | :  |,
          |   | | \   ||   |  |-,'   ;  \; /  |  ;   \  ' .'   :  ;;   . |  ; |--'
          '   : |  ; .''   :  ;/| \   \  ',  /    \   \   '|   |  '|   : |  | ,
          |   | '`--'  |   |    \  ;   :    /      \   `  ;'   :  ||   : '  |/
          '   : |      |   :   .'   \   \ .'        :   \ |;   |.' ;   | |`-'
          ;   |.'      |   | ,'      `---`           '---" '---'   |   ;/
          '---'        `----'                                      '---'
   ]],
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },
  {
    "ahmedkhalf/project.nvim",
    opts = {
      manual_mode = true,
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("project_nvim").setup(opts)
      local history = require("project_nvim.utils.history")
      history.delete_project = function(project)
        for k, v in pairs(history.recent_projects) do
          if v == project.value then
            history.recent_projects[k] = nil
            return
          end
        end
      end
    end,
  },

  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>fp", pick, desc = "Projects" },
    },
  },

  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.dashboard.preset.keys, 3, {
        action = pick,
        desc = "Projects",
        icon = " ",
        key = "p",
      })
    end,
  },
}
