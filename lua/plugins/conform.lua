return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    format_on_save = false,
    formatters_by_ft = {
      rust = { "rustfmt" },
      json = { "jq" },
      lua = { "stylua" },
      jsonc = { "jq" },
      java = { "google-java-format" },
      yaml = { "prettierd" }
    },
  },
}
