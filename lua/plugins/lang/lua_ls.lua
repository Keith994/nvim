local function selene_configured(path)
  return #vim.fs.find("selene.toml", { path = path, upward = true, type = "file" }) > 0
end
local list_insert_unique = utils.list_insert_unique
local is_aarch64 = vim.loop.os_uname().machine == "aarch64"
return {

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      local ret = {
        servers = {
          lua_ls = {
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
        },
      }
      return utils.extend_tbl(opts, ret)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = list_insert_unique(opts.ensure_installed, { "lua", "luap" })
      end
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = list_insert_unique(opts.ensure_installed, { "lua_ls" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = list_insert_unique(opts.ensure_installed, {
        "lua-language-server",
        "stylua",
        (not is_aarch64 and "selene") or nil,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        lua = { "stylua", lsp_format = "last" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      if not is_aarch64 then
        opts.linters_by_ft = {
          lua = { "selene" },
        }
        opts.linters = opts.linters or {}
        opts.linters.selene = {
          condition = function(ctx)
            return selene_configured(ctx.filename)
          end,
        }
      end
    end,
  },
}
