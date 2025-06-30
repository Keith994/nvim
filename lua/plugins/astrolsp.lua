-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing
if vim.g.vscode then return {} end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  -- version = "1.0.4",
  ---@type AstroLSPOpts
  opts = {
    autocmds = {
      lsp_codelens_refresh = false,
      lsp_auto_signature_help = false,
      lsp_auto_format = false,
    },
    -- Configuration table of features provided by AstroLSP
    features = {
      large_buf = true,
      autoformat = false, -- enable or disable auto formatting on start
      codelens = false, -- enable/disable codelens refresh on start
      inlay_hints = true, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
      signature_help = true,
    },
    -- enable servers that you already have installed without mason
    servers = {
      yamlls = {
        setting = {
          yaml = {
            format = {
              enable = false,
            },
            schemaStore = { enable = false, url = "" },
          },
        },
      },
      -- "pyright"
    },
    -- mappings to be set up on attaching of a language server
    -- stylua: ignore
    mappings = {
      n = {
        ["gy"] = { function() vim.lsp.buf.hover() end, desc = "Hover symbol details" },
        ["ga"] = { function() vim.lsp.buf.code_action() end, desc = "LSP code action" },
        ["gA"] = { function() vim.lsp.codelens.run() end, desc = "LSP CodeLens run", },
        ["gR"] = { function() vim.lsp.buf.rename() end, desc = "Rename current symbol" },
        ["gd"] = { function() require("snacks.picker").lsp_definitions() end, desc = "lsp defnition" },
        ["g<S-D>"] = { function() require("snacks.picker").lsp_type_definitions() end, desc = "Type Defnition" },
        ["gr"] = { function() require("snacks.picker").lsp_references() end, desc = "References of current symbol" },
        ["gl"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
        ["gI"] = { function() require("snacks.picker").lsp_implementations() end, desc = "lsp implementations" },
        ["<localleader>f"] = { function() vim.cmd.Format() end, desc = "Format Buffer" },
        ["<leader>lc"] = { function() require('snacks.picker').lsp_config() end, desc = "LSP configurations" },
        ["<leader>la"] = { function() vim.lsp.buf.code_action() end, desc = "LSP code action" },
        ["<leader>lR"] = { function() vim.lsp.buf.rename() end, desc = "Rename current symbol" },
        ["<leader>lr"] = { function() require("snacks.picker").lsp_implementations() end, desc = "lsp implementations" },
        ["<llader>lG"] = { function() require("snacks.picker").lsp_workspace_symbols() end, desc = "search workspace symbols" },
        ["<leader>ld"] = { "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open document diagnostics" },
        ["<leader>lw"] = { "<Cmd>Trouble diagnostics toggle<CR>", desc = "Open workspace diagnostics" },
        ["<Leader>lG"] = { function() require("snacks.picker").lsp_workspace_symbols() end,desc = "Search workspace symbols", },
        ["<Leader>lS"] = nil,
        ["<Leader>ls"] = { function() require("snacks.picker").lsp_symbols() end, desc = "Search symbols" },

        -- C-S-F9
        ["<F45>"] = { function() require("dap").clear_breakpoints() end, desc = "clear breakpoints" },
        -- C-f10
        ["<F34>"] = { function() require("dap").run_to_cursor() end, desc = "run_to_cursor" },
        ["<F9>"] = { function() require("dap").toggle_breakpoint() end, desc = "toggle_breakpoint" },
        ["<F12>"] = { function() require("dap-view").toggle() end, desc = "open dap view" },
        -- S-F9
        ["<F21>"] = { function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "condition_breakpoint", },
        ["K"] = { function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end, desc = "Next buffer", },
      },
      i = {
        ["<C-K>"] = { function() vim.lsp.buf.signature_help() end, desc = "signature help", },
      },
      v = {
        ["<LocalLeader>f"] = { function() vim.lsp.buf.format() end, desc = "Format code" },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr) end,
  },
}
