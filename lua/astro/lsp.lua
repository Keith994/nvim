local function keymaps(event)
  local map = function(keys, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
  end

  local picker = require("snacks.picker")

  map("gy", vim.lsp.buf.hover, "Hover Symbol Details")
  map("ga", vim.lsp.buf.code_action, "Code Action")
  map("gA", vim.lsp.codelens.run, "CodeLens Run")
  map("gd", picker.lsp_definitions, "Defnition")
  map("gD", picker.lsp_type_definitions, "Type Defnition")
  map("gr", picker.lsp_references, "Refereences Of Current Symbol")
  map("gR", vim.lsp.buf.rename, "Rename Current Symbol")
  map("gl", vim.diagnostic.open_float, "Hover Diagnostic")
  map("gI", picker.lsp_implementations, "Implementations")
  map("<c-k>", vim.lsp.buf.signature_help, "Signature Help", "i")
  map("<Leader>cl", picker.lsp_config, "Server Info")
  map("<Leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("<Leader>cc", vim.lsp.codelens.run, "CodeLens Run")
  map("<Leader>cC", vim.lsp.codelens.refresh, "Refresh CodeLens")
  map("<Leader>cR", vim.lsp.buf.rename, "Rename Current Symbol")
  map("<Leader>cr", picker.lsp_references, "Refereences Of Current Symbol")

  map("<Leader>cs", picker.lsp_symbols, "Symbols")
  map("<Leader>cS", picker.lsp_workspace_symbols, "Workspace Symbols")
  map("<Leader>cd", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", "Document Diagnostics")
  map("<Leader>cD", "<Cmd>Trouble diagnostics toggle<CR>", "Workspace Diagnostics")

  map("<F29>", function() -- C+F5
    require("dap").continue()
  end, "Debug: Start/Continue")
  map("<F5>", function()
    require("dap").continue()
  end, "Debug: Start/Continue")
  map("<S-F5>", function()
    require("dap").terminate()
  end, "Debug: Terminate")
  map("<F6>", function()
    require("dap").pause()
  end, "Debug: Pause")
  map("<F10>", function()
    require("dap").step_over()
  end, "Debug: Step Over")
  map("<F11>", function()
    require("dap").step_out()
  end, "Debug: Step Out")
  map("<F11>", function()
    require("dap").step_out()
  end, "Debug: Step Out")
  -- C-S-F9
  map("<F45>", require("dap").clear_breakpoints, "Clear Breakpoints")
  -- C-f10
  map("<F34>", require("dap").run_to_cursor, "Run To Cursor")
  map("<F9>", require("dap").toggle_breakpoint, "Toggle Breakpoint")
  -- S-F9
  map("<F21>", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, "Toggle Breakpoint")
end
return {
  "AstroNvim/astrolsp",
  lazy = true,
  ---@type AstroLSPOpts
  opts = {
    features = {
      codelens = true,
      inlay_hints = false,
      semantic_tokens = true,
    },
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    ---@diagnostic disable-next-line: missing-fields
    config = {},
    defaults = {
      hover = {
        border = "rounded",
        silent = true,
      },
      signature_help = {
        border = "rounded",
        silent = true,
        focusable = false,
      },
    },
    file_operations = {
      timeout = 10000,
      operations = {
        didCreate = true,
        didDelete = true,
        didRename = true,
        willCreate = true,
        willDelete = true,
        willRename = true,
      },
    },
    flags = {},
    formatting = { format_on_save = { enabled = true }, disabled = {} },
    handlers = { function(server, server_opts) require("lspconfig")[server].setup(server_opts) end },
    servers = {},
    on_attach = function (_, events)
      keymaps(events)
    end,
  },
  specs = {
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        autocmds = {
          astrolsp_createfiles_events = {
            {
              event = "BufWritePre",
              desc = "trigger willCreateFiles before writing a new file",
              callback = function(args)
                local filename = require("astrocore.buffer").is_valid(args.buf)
                  and vim.fn.expand("#" .. args.buf .. ":p")
                if filename and not vim.uv.fs_stat(filename) then
                  vim.b[args.buf].new_file = filename
                  require("astrolsp.file_operations").willCreateFiles(filename)
                end
              end,
            },
            {
              event = "BufWritePost",
              desc = "trigger didCreateFiles after writing a new file",
              callback = function(args)
                local filename = vim.b[args.buf].new_file
                if filename then
                  vim.b[args.buf].new_file = false
                  require("astrolsp.file_operations").didCreateFiles(filename)
                end
              end,
            },
          },
        },
      },
    },
  },
}
