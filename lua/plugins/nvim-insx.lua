return {
  {
    "windwp/nvim-autopairs",
    enabled = false,
  },
  {
    "hrsh7th/nvim-insx",
    config = function() require("insx.preset.standard").setup() end,
  },
}
