if vim.g.vscode then return {} end
local create_command = vim.api.nvim_create_user_command

function is_test_file()
  local file = vim.fn.expand('%')
  if #file <= 1 then
    vim.notify("no buffer name", vim.log.levels.ERROR)
    return
  end
  local is_test   = string.find(file, "_test%.go$")
  local is_source = string.find(file, "%.go$")
  return file, (not is_test and is_source), is_test
end

function alternate()
  local file, is_source, is_test = is_test_file()
  local alt_file = file
  if is_test then
    alt_file = string.gsub(file, "_test.go", ".go")
  elseif is_source then
    alt_file = vim.fn.expand('%:r') .. "_test.go"
  else
    vim.notify('not a go file', vim.log.levels.ERROR)
  end
  return alt_file
end

function switch(bang, cmd)
  local alt_file = alternate()
  if not vim.fn.filereadable(alt_file) and not vim.fn.bufexists(alt_file) and not bang then
    vim.notify("couldn't find " .. alt_file, vim.log.levels.ERROR)
    return
  elseif #cmd <= 1 then
    local ocmd = "e " .. alt_file
    vim.cmd(ocmd)
  else
    local ocmd = cmd .. " " .. alt_file
    vim.cmd(ocmd)
  end
end

return {
  {
    "AstroNvim/astrolsp",
    optional = true,
    ---@type AstroLSPOpts
    opts = {
      ---@diagnostic disable-next-line: missing-fields
      config = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                ST1003 = false,
                fieldalignment = false,
                fillreturns = true,
                nilness = true,
                nonewvars = true,
                shadow = true,
                undeclaredname = false,
                unreachable = true,
                unusedparams = false,
                unusedwrite = false,
                useany = true,
              },
              codelenses = {
                gc_details = true, -- Show a code lens toggling the display of gc's choices.
                generate = true,   -- show the `go generate` lens.
                regenerate_cgo = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              buildFlags = { "-tags", "integration" },
              completeUnimported = true,
              diagnosticsDelay = "500ms",
              matcher = "Fuzzy",
              semanticTokens = true,
              staticcheck = false,
              symbolMatcher = "fuzzy",
              usePlaceholders = true,
            },
          },
        },
      },
    },
  },
  -- Golang support
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed =
            require("astrocore").list_insert_unique(opts.ensure_installed, { "go", "gomod", "gosum", "gowork" })
      end
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
          require("astrocore").list_insert_unique(opts.ensure_installed,
            { "gomodifytags", "gofumpt", "iferr", "impl", "gotests", "goimports" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(
        opts.ensure_installed,
        { "delve", "gopls", "gomodifytags", "gofumpt", "gotests", "goimports", "iferr", "impl" }
      )
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "jay-babu/mason-nvim-dap.nvim",
        optional = true,
        opts = function(_, opts)
          opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "delve" })
        end,
      },
    },
    opts = {},
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    build = function()
      if not require("lazy.core.config").spec.plugins["mason.nvim"] then
        vim.print "Installing go dependencies..."
        vim.cmd.GoInstallDeps()
      end
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "williamboman/mason.nvim", optional = true }, -- by default use Mason for go dependencies
    },
    opts = function(_, opts)
      create_command("GoAlt", function() switch(nil, '') end, { desc = "Alt File" })
      create_command("GoAltV", function() switch(nil, 'vsplit') end, { desc = "Alt File vsplit" })
      create_command("GoAltS", function() switch(nil, 'vsplit') end, { desc = "Alt File split" })
      local utils = require "astrocore"
      return utils.extend_tbl(opts, {
        gotag = {
          transform = "camelcase",
          -- default tags to add to struct fields
          default_tag = "json",
        }
      })
    end,
  },
  -- {
  --   "ray-x/go.nvim",
  --   -- commit = "591a0b8",
  --   ft = { "go", "gomod" },
  --   dependencies = {
  --     {
  --       "ray-x/guihua.lua",
  --       -- commit = "3b3126a"
  --     },
  --   },
  --   opts = function()
  --     local opts = {
  --       -- verbose = true,
  --       log_path = vim.fn.expand "$HOME" .. "/tmp/gonvim.log",
  --       lsp_codelens = false,
  --       comment_placeholder = "Keith",
  --       dap_debug = true,
  --       dap_debug_gui = false,
  --       dap_debug_vt = true,
  --       dap_debug_keymap = false, -- true: use keymap for debugger defined in go/dap.lua
  --       run_in_floaterm = true, -- set to true to run in float window.
  --       icons = false,
  --       sign_priority = 500,
  --       lsp_inlay_hints = {
  --         enable = false,
  --       },
  --     }
  --
  --     return opts
  --   end,
  -- },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "fredrikaverpil/neotest-golang" },
    opts = function(_, opts)
      if not opts.adapters then opts.adapters = {} end
      table.insert(opts.adapters, require "neotest-golang" (require("astrocore").plugin_opts "neotest-golang"))
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        go = { "goimports", lsp_format = "last" },
      },
    },
  },
  {
    "echasnovski/mini.icons",
    optional = true,
    opts = {
      file = {
        [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
      },
      filetype = {
        gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
      },
    },
  },
}
