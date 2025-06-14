return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    -- virtual text for the debugger
    {
      "theHamsta/nvim-dap-virtual-text",
      enabled = false,
      opts = {},
    },
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local dapui = require "dapui"
        local windows = require "dapui.windows"
        local maps = opts.mappings
        local toggleUI = function(num)
          if windows.layouts[num]:is_open() then
            dapui.close { layout = num }
          else
            dapui.open { layout = num }
          end
        end
        maps.n["<Leader>du"] = {
          function()
            toggleUI(3)
          end,
          desc = "Toggle Debugger UI"
        }
        maps.n["<Leader>dv"] = {
          function()
            toggleUI(4)
          end,
          desc = "Toggle Debugger UI"
        }
        -- maps.n["<Leader>duo"] = {
        --   function()
        --     toggleUI(1)
        --     toggleUI(3)
        --   end,
        --   desc = "Open Debugger UI",
        -- }
      end,
    },
  },
  opts = function(_, opts)
    local utils = require "astrocore"
    return utils.extend_tbl {
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
    }
  end,
  config = function(_, opts)
    local dap, dapui = require "dap", require "dapui"

    dap.listeners.after.event_initialized.dapui_config = function()
      dapui.open { layout = 3 }
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      print "Dap终止"
      dapui.close { layout = 3 }
    end
    dap.listeners.before.event_exited.dapui_config = function() end

    dapui.setup(opts)
  end,
}
