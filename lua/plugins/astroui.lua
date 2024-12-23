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
    colorscheme = "tokyonight",
    -- colorscheme = "catppuccin",
    -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
    highlights = {
      init = { -- this table overrides highlights in all themes
        -- Normal = { bg = "#000000" },
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
        local bg_color = "#21242c"
        local fg_color = "#f5f6fa"
        hl.fg = fg_color
        hl.bg = bg_color
        hl.section_fg = fg_color
        hl.section_bg = bg_color

        hl.blank_bg = bg_color

        hl.mode_fg = fg_color
        hl.mode_right = "#009688"

        hl.file_info_fg = "#2d3436"
        hl.file_info_bg = "#00BCD4"

        -- hl.inactive = HeirlineInactive
        hl.normal = "#4CAF50"
        hl.insert = "#009688"
        hl.visual = "#3F51B5"
        hl.replace = "#E91E63"
        hl.command = "#FFC107"
        hl.terminal = "#795548"

        hl.git_branch_fg = "#2d3436"
        hl.git_branch_bg = "#B6CAE2"

        hl.git_diff = "#9E9E9E"

        -- hl.git_added = "#e74c3c"
        -- hl.git_changed = "#e67e22"
        -- hl.git_removed = "#f1c40f"

        hl.folder_icon_bg = "#9D0654"
        hl.folder_bg = "#B20960"

        hl.word_file_icon_bg = "#E7BB0D"
        hl.word_file_bg = "#FFDE59"

        hl.scroll_text_icon_bg = "#A7D350"
        hl.scroll_text_bg = "#B3E255"
        return hl
      end,
    },
  },
}
