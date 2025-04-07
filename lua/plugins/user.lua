-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:
if vim.g.vscode then return {} end

---@type LazySpec
return {

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
  -- {
  --   "phaazon/hop.nvim",
  --   branch = "v2",
  --   cmd = { "HopWord", "HopChar1" },
  --   config = function() require("hop").setup {} end,
  -- },
  {
    "glepnir/nerdicons.nvim",
    cmd = { "NerdIcons" },
    config = function() require("nerdicons").setup {} end,
  },
}
