-- AstroUI provides the basis for configuring the AstroNvim User Interface
-- Configuration documentation can be found with `:h astroui`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing
if vim.g.vscode then return {} end

---@type LazySpec
return {
  "AstroNvim/astroui",
  ---@type AstroUIOpts
  opts = {
    -- change colorscheme
    colorscheme = "carbonfox",
    -- colorscheme = "catppuccin",
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = { -- this table overrides highlights in all themes
        -- Normal = { bg = "#000000" },
        NonText = {
          fg = "#B6B8BB"
        },
      },
      astrotheme = { -- a table of overrides/changes when applying the astrotheme theme
        -- Normal = { bg = "#000000" },
      },
    },
    -- Icons can be configured throughout the interface
    icons = {
      VimIcon = "",
      ScrollText = "",
      GitBranch = "",
      GitAdd = "",
      GitChange = "",
      GitDelete = "",
      -- configure the loading of the lsp in the status line
      LSPLoading1 = "⠋",
      LSPLoading2 = "⠙",
      LSPLoading3 = "⠹",
      LSPLoading4 = "⠸",
      LSPLoading5 = "⠼",
      LSPLoading6 = "⠴",
      LSPLoading7 = "⠦",
      LSPLoading8 = "⠧",
      LSPLoading9 = "⠇",
      LSPLoading10 = "⠏",
    },
    status = {
      attributes = {
        mode = { bold = false },
        git_branch = { bold = false },
        git_diff = { bold = false },
      },
      icon_highlights = {
        breadcrumbs = true,
        file_icon = {
          statusline = true,
        },
      },
      separators = {
        breadcrumbs = "  ",
        path = "  ",
        left = { "", " " }, -- separator for the left side of the statusline
        right = { " ", "" }, -- separator for the right side of the statusline
        tab = { "", "" },
      },
      colors = function(hl)
        hl.mode_right_bg = hl.normal

        hl.folder_icon_bg = "#B20980"
        hl.folder_bg = "#B20960"

        hl.word_file_icon_bg = "#cf8d2e"
        hl.word_file_bg = "#cf8d10"

        hl.scroll_text_icon_bg = "#279b37"
        hl.scroll_text_bg = "#279b00"
        return hl
      end,
    },
  },
}
