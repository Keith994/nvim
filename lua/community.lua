-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.recipes.vscode" },
  -- { import = "astrocommunity.bars-and-lines.dropbar-nvim" },
  -- { import = "astrocommunity.recipes.astrolsp-auto-signature-help" },
  { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.recipes.telescope-lsp-mappings" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.astro" },
  { import = "astrocommunity.pack.nix" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.markdown" },
  -- { import = "astrocommunity.markdown-and-latex.markview-nvim" },
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.fish" },
  { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.pack.bash" },
  -- { import = "astrocommunity.icon.mini-icons" },
  -- { import = "astrocommunity.pack.full-dadbod" },
  -- {
  --   "kristijanhusak/vim-dadbod-ui",
  --   init = function()
  --     vim.g.db_ui_use_nerd_fonts = 1
  --     vim.g.dbs = require "plugins.dbs_url.dbs"
  --     vim.g.db_ui_save_location = "~/db_ui_queries"
  --     vim.g.db_ui_win_position = "right"
  --     -- vim.g.db_ui_disable_mappings = 1
  --     vim.g.db_ui_show_database_icon = 1
  --   end,
  -- },
  { import = "astrocommunity.pack.hyprlang" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.cs" },
  -- { import = "astrocommunity.pack.java" },
  -- { import = "astrocommunity.fuzzy-finder.fzf-lua" },
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.editing-support.bigfile-nvim" },
  { import = "astrocommunity.editing-support.suda-vim" },
  { import = "astrocommunity.editing-support.mini-splitjoin" },
  -- { import = "astrocommunity.editing-support.nvim-ts-rainbow2" },
  { import = "astrocommunity.test.neotest" },
  { import = "astrocommunity.test.nvim-coverage" },
  { import = "astrocommunity.motion.leap-nvim" },
  { import = "astrocommunity.motion.mini-bracketed" },
  { import = "astrocommunity.motion.mini-surround" },
  { import = "astrocommunity.syntax.hlargs-nvim" },
  { import = "astrocommunity.search.nvim-spectre" },
  { import = "astrocommunity.comment.mini-comment" },
  { import = "astrocommunity.programming-language-support.nvim-jqx" },
  -- { import = "astrocommunity.completion.blink-cmp" }, -- 免费的AI编程助手，会收集信息
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.git.blame-nvim" },
  { import = "astrocommunity.debugging.telescope-dap-nvim" },
  -- { import = "astrocommunity.game.leetcode" },
  -- { import = "astrocommunity.debugging.persistent-breakpoints-nvim" },
}
