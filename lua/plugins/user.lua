-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:
if vim.g.vscode then return {} end

---@type LazySpec
return {

  -- == Examples of Adding Plugins ==

  "andweeb/presence.nvim",

  -- == Examples of Overriding Plugins ==

  -- customize alpha options
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        " █████  ███████ ████████ ██████   ██████",
        "██   ██ ██         ██    ██   ██ ██    ██",
        "███████ ███████    ██    ██████  ██    ██",
        "██   ██      ██    ██    ██   ██ ██    ██",
        "██   ██ ███████    ██    ██   ██  ██████",
        " ",
        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      return opts
    end,
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  -- {
  --   "windwp/nvim-autopairs",
  --   enabled = true,
  --   config = function(plugin, opts)
  --     require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
  --     -- add more custom autopairs configuration such as custom rules
  --     local npairs = require "nvim-autopairs"
  --     local Rule = require "nvim-autopairs.rule"
  --     local cond = require "nvim-autopairs.conds"
  --     npairs.add_rules(
  --       {
  --         Rule("$", "$", { "tex", "latex" })
  --           -- don't add a pair if the next character is %
  --           :with_pair(cond.not_after_regex "%%")
  --           -- don't add a pair if  the previous character is xxx
  --           :with_pair(
  --             cond.not_before_regex("xxx", 3)
  --           )
  --           -- don't move right when repeat character
  --           :with_move(cond.none())
  --           -- don't delete if the next character is xx
  --           :with_del(cond.not_after_regex "xx")
  --           -- disable adding a newline when you press <cr>
  --           :with_cr(cond.none()),
  --       },
  --       -- disable for .vim files, but it work for another filetypes
  --       Rule("a", "a", "-vim")
  --     )
  --   end,
  -- },
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
    "phaazon/hop.nvim",
    branch = "v2",
    cmd = { "HopWord", "HopChar1" },
    config = function() require("hop").setup {} end,
  },
  {
    "nanotee/sqls.nvim",
    ft = "sql",
  },
  {
    "onsails/lspkind.nvim",
    opts = {
      mode = "symbol",
      symbol_map = {
        Array = "",
        Boolean = "⊨",
        Class = "",
        Constructor = "",
        Key = "",
        Namespace = "",
        Null = "NULL",
        Number = "#",
        Object = "",
        Package = "",
        Property = "",
        Reference = "",
        Snippet = "",
        String = "",
        TypeParameter = "",
        Unit = "",
      },
      before = function(entry, vim_item)
        vim_item.menu = ({
          buffer = "[BUF]",
          nvim_lsp = "[LSP]",
          luasnip = "[SNIP]",
          treesitter = "[TS]",
          nvim_lua = "[LUA]",
          spell = "[SPELL]",
          path = "[PATH]",
          orgmode = "[ORG]",
        })[entry.source.name]
        return vim_item
      end,
    },
  },
  {
    "glepnir/nerdicons.nvim",
    cmd = { "NerdIcons" },
    config = function() require("nerdicons").setup {} end,
  },
}
