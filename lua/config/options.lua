-- This file is automatically loaded by plugins.core
vim.g.mapleader = " "
vim.g.maplocalleader = ","

local opt = vim.opt

opt.backspace = vim.list_extend(vim.opt.backspace:get(), { "nostop" }) -- don't stop backspace at insert
opt.breakindent = true -- wrap indent to match  line start
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.cmdheight = 0 -- hide command line unless needed
opt.completeopt = { "menu", "menuone", "noselect" } -- Options for insert mode completion
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.diffopt = vim.list_extend(vim.opt.diffopt:get(), { "algorithm:histogram", "linematch:60" }) -- enable linematch diff algorithm
opt.expandtab = true -- Use spaces instead of tabs
opt.showbreak = ""
opt.fillchars = {
  eob = " ",
}
opt.ignorecase = true -- Ignore case
opt.jumpoptions = {}

opt.laststatus = 3 -- global statusline
opt.linebreak = true -- wrap lines at 'breakat'
opt.mouse = "a" -- enable mouse support
opt.number = true -- show numberline
opt.preserveindent = true -- preserve indent structure as much as possible
opt.pumheight = 10 -- height of the pop up menu
opt.relativenumber = true -- show relative numberline
opt.shiftround = true -- round indentation with `>`/`<` to shiftwidth
opt.shiftwidth = 0 -- number of space inserted for indentation; when zero the 'tabstop' value will be used
opt.shortmess = vim.tbl_deep_extend("force", vim.opt.shortmess:get(), { s = true, I = true, c = true, C = true }) -- disable search count wrap, startup messages, and completion messages
opt.showmode = false -- disable showing modes in command line
opt.showtabline = 2 -- always display tabline
opt.signcolumn = "yes" -- always show the sign column
opt.smartcase = true -- case sensitive searching
opt.splitbelow = true -- splitting a new window below the current one
opt.splitright = true -- splitting a new window at the right of the current one
opt.tabstop = 2 -- number of space in a tab
opt.termguicolors = true -- enable 24-bit RGB color in the TUI
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.title = true -- set terminal title to the filename and path
opt.undofile = true -- enable persistent undo
opt.updatetime = 300 -- length of time to wait before triggering the plugin
opt.virtualedit = "block" -- allow going past end of line in visual block mode
opt.wrap = false -- disable wrapping of lines longer than the width of window
opt.writebackup = false -- disable making a backup before overwriting a file
opt.formatexpr = "v:lua.require'conform'.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.inccommand = "nosplit" -- preview incremental substitute
opt.list = true -- Show some invisible characters (tabs...
opt.pumblend = 10 -- Popup blend
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.sidescrolloff = 8 -- Columns of context
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitkeep = "screen"
-- opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
opt.undolevels = 10000
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width

opt.foldcolumn = "1" -- display fold column
opt.foldenable = true -- enable folds
opt.foldlevel = 99 -- set high foldlevel
opt.foldlevelstart = 99
opt.foldmethod = "expr" -- use `foldexpr` for calculating folds
opt.foldtext = "" -- use transparent foldtext
opt.foldexpr = "v:lua.require'astroui.folding'.foldexpr()"

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

if not vim.t.bufs then
  vim.t.bufs = vim.api.nvim_list_bufs()
end -- initialize buffer list

vim.g.markdown_recommended_style = 0
