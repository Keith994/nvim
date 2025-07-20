---@type LazySpec
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "fang2hou/blink-copilot" },
    opts = {
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
  {
    "echasnovski/mini.icons",
    optional = true,
    -- Adds icon for copilot using mini.icons
    opts = function(_, opts)
      if not opts.lsp then
        opts.lsp = {}
      end
      if not opts.symbol_map then
        opts.symbol_map = {}
      end
      opts.symbol_map.copilot = { glyph = "", hl = "MiniIconsAzure" }
    end,
  },
}
