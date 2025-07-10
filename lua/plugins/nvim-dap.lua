return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        keys = { "<leader>du", "<leader>dv" },
        opts = function(opts)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { desc = desc })
          end

          local dapui = require("dapui")
          local windows = require("dapui.windows")
          local toggleUI = function(num)
            if windows.layouts[num]:is_open() then
              dapui.close({ layout = num })
            else
              dapui.open({ layout = num })
            end
          end
          map("<Leader>du", function()
            toggleUI(3)
          end, "Toggle Debugger UI")
          map("<Leader>dv", function()
            toggleUI(4)
          end, "Toggle Debugger UI")

          local utils = utils
          return utils.extend_tbl({
            layouts = {
              {
                elements = {
                  {
                    id = "scopes",
                    size = 0.35,
                  },
                  {
                    id = "watches",
                    size = 0.35,
                  },
                  {
                    id = "breakpoints",
                    size = 0.15,
                  },
                  {
                    id = "stacks",
                    size = 0.15,
                  },
                },
                position = "left",
                size = 40,
              },
              {
                elements = {
                  {
                    id = "repl",
                    size = 0.5,
                  },
                  {
                    id = "console",
                    size = 0.5,
                  },
                },
                position = "bottom",
                size = 10,
              },
              {
                elements = {
                  {
                    id = "watches",
                    size = 0.5,
                  },
                  {
                    id = "repl",
                    size = 0.5,
                  },
                },
                position = "bottom",
                size = 12,
              },
              {
                elements = {
                  {
                    id = "console",
                    size = 1,
                  },
                },
                position = "right",
                size = 50,
              },
            },
          })
        end,
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dap.listeners.after.event_initialized.dapui_config = function()
            dapui.open({ layout = 3 })
          end
          dap.listeners.before.event_terminated.dapui_config = function()
            print("Dap终止")
            dapui.close({ layout = 3 })
          end
          dap.listeners.before.event_exited.dapui_config = function() end

          dapui.setup(opts)
        end,
      },

      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "nvim-dap", "mason-org/mason.nvim" },
        cmd = { "DapInstall", "DapUninstall" },
        opts_extend = { "ensure_installed" },
        opts = { ensure_installed = {}, handlers = {} },
        config = function(_, opts)
          if require("astrocore").is_available("mason-tool-installer.nvim") then
            opts.ensure_installed = nil
          end
          require("mason-nvim-dap").setup(opts)
        end,
      },
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        conidtion = vim.g.enable_dap_virtual,
        opts = {},
      },
      {
        "rcarriga/cmp-dap",
        lazy = true,
        config = function(_, opts)
          local blink_avail, blink = pcall(require, "blink.cmp")
          if blink_avail then
            for _, dap_ft in ipairs({ "dap-repl", "dapui_watches", "dapui_hover" }) do
              blink.add_filetype_source(dap_ft, "dap")
            end
          end
        end,
        specs = {
          {
            "Saghen/blink.cmp",
            optional = true,
            specs = { "Saghen/blink.compat", lazy = true, opts = {} },
            opts = {
              sources = {
                providers = {
                  dap = {
                    name = "dap",
                    module = "blink.compat.source",
                    score_offset = 100,
                  },
                },
              },
            },
          },
        },
      },
    },

    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },

    config = function()
      local parser, cleaner
      local vscode = require("dap.ext.vscode")
      vscode.json_decode = function(str)
        if cleaner == nil then
          local plenary_avail, plenary = pcall(require, "plenary.json")
          cleaner = plenary_avail and function(s)
            return plenary.json_strip_comments(s, {})
          end or false
        end
        if not parser then
          local json5_avail, json5 = pcall(require, "json5")
          parser = json5_avail and json5.parse or vim.json.decode
        end
        if type(cleaner) == "function" then
          str = cleaner(str)
        end
        local parsed_ok, parsed = pcall(parser, str)
        if not parsed_ok then
          require("astrocore").notify("Error parsing `.vscode/launch.json`.", vim.log.levels.ERROR)
          parsed = {}
        end
        return parsed
      end
    end,
  },
}
