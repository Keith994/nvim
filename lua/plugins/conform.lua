return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      rust = { "rustfmt" },
      json = { "jq" },
      lua = { "stylua" },
      jsonc = { "jq" },
      java = { "google-java-format" }
    },
  },
}
