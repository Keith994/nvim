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
    -- Configuration table of features provided by AstroLSP
    features = {
      large_buf = false,
      autoformat = false, -- enable or disable auto formatting on start
      codelens = true, -- enable/disable codelens refresh on start
      inlay_hints = false, -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = false, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
          "go",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 3000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      ["rust-analyzer"] = {

        -- on_attach = function(_, _)
        --   vim.defer_fn(function()
        --     local maps = { n = {} }
        --     maps.n["<F5>"] = { "<cmd>RustDebuggables<cr>", desc = "start rust debug" }
        --     core.set_mappings(astronvim.user_opts("lsp.mappings", maps))
        --   end, 5000)
        -- end,
      },
      sqlls = {
        on_attach = function(client, bufnr) require("sqls").on_attach(client, bufnr) end,
      },
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_document_highlight = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/documentHighlight",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "CursorHold", "CursorHoldI" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Document Highlighting",
          callback = function() vim.lsp.buf.document_highlight() end,
        },
        {
          event = { "CursorMoved", "CursorMovedI", "BufLeave" },
          desc = "Document Highlighting Clear",
          callback = function() vim.lsp.buf.clear_references() end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    mappings = {
      n = {
        ["gy"] = { function() vim.lsp.buf.hover() end, desc = "Hover symbol details" },
        ["<leader>la"] = { function() vim.lsp.buf.code_action() end, desc = "LSP code action" },
        ["ga"] = { function() vim.lsp.buf.code_action() end, desc = "LSP code action" },
        ["gA"] = {
          function() vim.lsp.codelens.run() end,
          desc = "LSP CodeLens run",
        },
        ["<localleader>f"] = { function() vim.lsp.buf.format() end, desc = "Format code" },
        ["gR"] = { function() vim.lsp.buf.rename() end, desc = "Rename current symbol" },
        ["g<S-D>"] = { "<Cmd>Trouble lsp_type_definitions toggle<CR>", desc = "Type Defnition" },
        ["gr"] = { "<cmd>Trouble lsp_references<CR>", desc = "References of current symbol" },
        ["<leader>ld"] = { "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Open document diagnostics" },
        ["<leader>lw"] = { "<Cmd>Trouble diagnostics toggle<CR>", desc = "Open workspace diagnostics" },
        ["[d"] = { function() vim.diagnostic.goto_prev {} end, desc = "Previous diagnostic" },
        ["]d"] = { function() vim.diagnostic.goto_next() end, desc = "Next diagnostic" },
        ["gl"] = { function() vim.diagnostic.open_float() end, desc = "Hover diagnostics" },
        -- C-S-F9
        ["<F45>"] = { function() require("dap").clear_breakpoints() end, desc = "run_to_cursor" },
        -- C-f10
        ["<F34>"] = { function() require("dap").run_to_cursor() end, desc = "run_to_cursor" },
        ["<F9>"] = { function() require("dap").toggle_breakpoint() end, desc = "toggle_breakpoint" },
        ["<F12>"] = { function() require("dapui").toggle() end, desc = "open dapui" },
        -- S-F9
        ["<F21>"] = {
          function()
            vim.ui.input(
              { prompt = "Breakpoint condition: " },
              function(input) require("dap").set_breakpoint(input) end
            )
          end,
          desc = "condition_breakpoint",
        },
        ["K"] = {
          function() require("astrocore.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
          desc = "Next buffer",
        },

        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        -- gD = {
        --   function() vim.lsp.buf.declaration() end,
        --   desc = "Declaration of current symbol",
        --   cond = "textDocument/declaration",
        -- },
        -- ["<Leader>uY"] = {
        --   function() require("astrolsp.toggles").buffer_semantic_tokens() end,
        --   desc = "Toggle LSP semantic highlight (buffer)",
        --   cond = function(client) return client.server_capabilities.semanticTokensProvider and vim.lsp.semantic_tokens end,
        -- },
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
