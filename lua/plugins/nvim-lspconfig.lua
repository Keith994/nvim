local function extend_or_override(config, custom, ...)
  if type(custom) == "function" then
    config = custom(config, ...) or config
  elseif custom then
    config = vim.tbl_deep_extend("force", config, custom) --[[@as table]]
  end
  return config
end
-- LSP keymaps
return {
  "neovim/nvim-lspconfig",
  -- stylua: ignore
  opts = function(_, opts)
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- disable a keymap
    keys[#keys + 1] = { "K", false }
    keys[#keys + 1] = { "gy",function() return vim.lsp.buf.hover() end, desc = "Hover" }
    keys[#keys + 1] = { "ga", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" }
    keys[#keys + 1] = { "gA", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, has = "codeLens" }
    keys[#keys + 1] = { "gl", vim.diagnostic.open_float, desc = "Hover diagnostics", mode = { "n" } }
    keys[#keys + 1] = { "gR", vim.lsp.buf.rename, desc = "Rename", mode = { "n" }, has = "rename" }

    return extend_or_override(opts, {
        inlay_hints = {
          enabled = false,
          exclude = { "vue", }, -- filetypes for which you don't want to enable inlay hints
        },
    })
  end,
}
