local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("config")

require("lazy").setup({
  spec = {
    -- import/override with your plugins
    { import = "vscode_setup" },
    { import = "plugins" },
    { import = "plugins/lang" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = false, -- check for plugin updates periodically
    notify = false,  -- notify on update
  },                 -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchparen",
        -- "matchit",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
if vim.g.vscode then
  return
end
-- init.lua (或者你主要的配置文件)
vim.defer_fn(function()
  vim.cmd.colorscheme("cyberdream")
end, 0)
--
-- -- ==========================================================================
-- -- 3. Matugen 热更新逻辑
-- -- ==========================================================================
-- local function source_matugen()
--   local matugen_path = vim.fn.stdpath('config') .. "/generated.lua"
--
--   local f = io.open(matugen_path, "r")
--   if f ~= nil then
--     io.close(f)
--     -- 尝试执行生成的文件
--     local ok, err = pcall(dofile, matugen_path)
--     if not ok then
--       -- 如果加载出错，只打印提示，不阻断启动
--       vim.notify("Matugen Load Error: " .. err)
--     end
--   else
--     -- 如果还没有生成过文件，使用内置主题兜底
--     vim.cmd.colorscheme('cyberdream') 
--   end
-- end
--
-- -- 热重载函数
-- local function matugen_reload()
--   -- 重新加载颜色
--   source_matugen()
--
--   -- 如果你有 lualine，可以在这里刷新
--   -- package.loaded['lualine'] = nil
--   -- require('lualine').setup({ options = { theme = 'base16' } })
--
--   -- 修复一些高亮丢失
--   vim.api.nvim_set_hl(0, "Comment", { italic = true })
-- end
--
-- -- 监听 Matugen 发出的信号
-- vim.api.nvim_create_autocmd("Signal", {
--   pattern = "SIGUSR1",
--   callback = function()
--     matugen_reload()
--     vim.notify("Matugen 颜色已更新！")
--   end,
-- })
--
-- -- 启动时加载一次
-- source_matugen()
