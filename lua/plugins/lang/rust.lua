local pack = {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "rust", "toml" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      -- make sure mason installs the server
      handlers = { rust_analyzer = false }, -- disable setup of `rust_analyzer`
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              files = {
                excludeDirs = {
                  ".direnv",
                  ".git",
                  "target",
                },
              },
              check = {
                command = "clippy",
                extraArgs = {
                  "--no-deps",
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "taplo" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "codelldb" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = utils.list_insert_unique(opts.ensure_installed, { "codelldb", "taplo" })
    end,
  },
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = { enabled = true },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      if not opts.adapters then
        opts.adapters = {}
      end
      local rustaceanvim_avail, rustaceanvim = pcall(require, "rustaceanvim.neotest")
      if rustaceanvim_avail then
        table.insert(opts.adapters, rustaceanvim)
      end
    end,
  },
}

-- Rustaceanvim v5 supports neovim v0.10+
table.insert(pack, {
  "mrcjkb/rustaceanvim",
  version = "^6",
  ft = "rust",
  opts = function()
    local adapter
    local codelldb_installed = pcall(function()
      return require("mason-registry").get_package("codelldb")
    end)
    local cfg = require("rustaceanvim.config")
    if codelldb_installed then
      local codelldb_path = vim.fn.exepath("codelldb")
      local this_os = vim.uv.os_uname().sysname

      local liblldb_path = vim.fn.expand("$MASON/share/lldb")
      -- The path in windows is different
      if this_os:find("Windows") then
        liblldb_path = liblldb_path .. "\\bin\\lldb.dll"
      else
        -- The liblldb extension is .so for linux and .dylib for macOS
        liblldb_path = liblldb_path .. "/lib/liblldb" .. (this_os == "Linux" and ".so" or ".dylib")
      end
      adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
    else
      adapter = cfg.get_codelldb_adapter()
    end

    local server = {
      ---@type table | (fun(project_root:string|nil, default_settings: table|nil):table) -- The rust-analyzer settings or a function that creates them.
      settings = function(project_root, default_settings)

        local ra = require("rustaceanvim.config.server")
        -- load_rust_analyzer_settings merges any found settings with the passed in default settings table and then returns that table
        return ra.load_rust_analyzer_settings(project_root, {
          settings_file_pattern = "rust-analyzer.json",
          default_settings = default_settings,
        })
      end,
    }
    local final_server = server
    return {
      server = final_server,
      dap = { adapter = adapter, load_rust_types = true },
      tools = { enable_clippy = false },
    }
  end,
  config = function(_, opts)
    vim.g.rustaceanvim = utils.extend_tbl(opts, vim.g.rustaceanvim)
  end,
})

return pack
