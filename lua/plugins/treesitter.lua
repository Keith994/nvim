return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  main = "nvim-treesitter.configs",
  dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true } },
  event = "BufReadPre",
  lazy = vim.fn.argc(-1) == 0, -- load treesitter immediately when opening a file from the cmdline
  cmd = {
    "TSBufDisable",
    "TSBufEnable",
    "TSBufToggle",
    "TSDisable",
    "TSEnable",
    "TSToggle",
    "TSInstall",
    "TSInstallInfo",
    "TSInstallSync",
    "TSModuleInfo",
    "TSUninstall",
    "TSUpdate",
    "TSUpdateSync",
  },
  build = ":TSUpdate",
  init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
    -- no longer trigger the **nvim-treeitter** module to be loaded in time.
    -- Luckily, the only thins that those plugins need are the custom queries, which we make available
    -- during startup.
    -- CODE FROM LazyVim (thanks folke!) https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
    require("lazy.core.loader").add_to_rtp(plugin)
    pcall(require, "nvim-treesitter.query_predicates")
  end,
  opts_extend = { "ensure_installed" },
  opts = function(_, opts)
    if utils.is_available("mason.nvim") then
      require("lazy").load({ plugins = { "mason.nvim" } })
    end
    opts = utils.extend_tbl(opts, {
      auto_install = vim.fn.executable("tree-sitter") == 1, -- only enable auto install if `tree-sitter` cli is installed
      highlight = { enable = true },
      incremental_selection = { enable = true },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["ak"] = { query = "@block.outer", desc = "around block" },
            ["ik"] = { query = "@block.inner", desc = "inside block" },
            ["ac"] = { query = "@class.outer", desc = "around class" },
            ["ic"] = { query = "@class.inner", desc = "inside class" },
            ["a?"] = { query = "@conditional.outer", desc = "around conditional" },
            ["i?"] = { query = "@conditional.inner", desc = "inside conditional" },
            ["af"] = { query = "@function.outer", desc = "around function " },
            ["if"] = { query = "@function.inner", desc = "inside function " },
            ["ao"] = { query = "@loop.outer", desc = "around loop" },
            ["io"] = { query = "@loop.inner", desc = "inside loop" },
            ["aa"] = { query = "@parameter.outer", desc = "around argument" },
            ["ia"] = { query = "@parameter.inner", desc = "inside argument" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]k"] = { query = "@block.outer", desc = "Next block start" },
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
          },
          goto_next_end = {
            ["]K"] = { query = "@block.outer", desc = "Next block end" },
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
            ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
          },
          goto_previous_start = {
            ["[k"] = { query = "@block.outer", desc = "Previous block start" },
            ["[f"] = { query = "@function.outer", desc = "Previous function start" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
          },
          goto_previous_end = {
            ["[K"] = { query = "@block.outer", desc = "Previous block end" },
            ["[F"] = { query = "@function.outer", desc = "Previous function end" },
            ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
          },
        },
        swap = {
          enable = true,
          swap_next = {
            [">K"] = { query = "@block.outer", desc = "Swap next block" },
            [">F"] = { query = "@function.outer", desc = "Swap next function" },
            [">A"] = { query = "@parameter.inner", desc = "Swap next argument" },
          },
          swap_previous = {
            ["<K"] = { query = "@block.outer", desc = "Swap previous block" },
            ["<F"] = { query = "@function.outer", desc = "Swap previous function" },
            ["<A"] = { query = "@parameter.inner", desc = "Swap previous argument" },
          },
        },
      },
    })
    if opts.ensure_installed ~= "all" then
      opts.ensure_installed = utils.list_insert_unique(
        opts.ensure_installed,
        { "bash", "c", "lua", "markdown", "markdown_inline", "python", "query", "vim", "vimdoc" }
      )
    end
    return opts
  end,
  config = function(plugin, opts)
    local ts = require(plugin.main)

    -- if no compiler or git available, disable installation
    if
        vim.fn.executable("git") == 0
        or not vim.tbl_contains(require("nvim-treesitter.install").compilers, function(c)
          return c ~= vim.NIL and vim.fn.executable(c) == 1
        end, { predicate = true })
    then
      opts.auto_install = false
      opts.ensure_installed = nil
    end

    -- disable all treesitter modules on large buffer
    for _, module in ipairs(ts.available_modules()) do
      if not opts[module] then
        opts[module] = {}
      end
      local module_opts = opts[module]
      local disable = module_opts.disable
      module_opts.disable = function(lang, bufnr)
        return (type(disable) == "table" and vim.tbl_contains(disable, lang))
            or (type(disable) == "function" and disable(lang, bufnr))
      end
    end

    ts.setup(opts)
  end,
}
