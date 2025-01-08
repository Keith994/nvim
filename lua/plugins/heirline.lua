if vim.g.vscode then return {} end
return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require "astroui.status"
    opts.statusline = {
      hl = { fg = "fg", bg = "bg" },

      status.component.mode {
        mode_text = { icon = { kind = "VimIcon", padding = { right = 1, left = 1 } } },
        surround = {
          separator = "left",
          color = function() return { main = status.hl.mode_bg(), right = "mode_right_bg" } end,
        },
      },
      status.component.builder {
        { provider = "" },
        surround = { separator = "left", color = { main = status.hl.mode_bg() } },
      },
      status.component.file_info {
        file_icon = { padding = { left = 0 } },
        filename = { fallback = "Empty" },
        filetype = false,
        hl = { fg = "fg", bg = "bg" },
        surround = {
          separator = "left",
          condition = false,
          color = { main = "bg", },
        },
      },
      status.component.git_branch {
        surround = { separator = "left", color = { main = "git_branch_bg", right = "bg" } },
      },
      status.component.git_diff {
        padding = { left = 1 },
        surround = { separator = "left", condition = false, color = { main = "bg" } },
      },
      status.component.fill(),
      status.component.lsp { lsp_client_names = false, surround = { separator = "none", color = "bg" } },
      status.component.fill(),
      status.component.diagnostics { surround = { separator = "right" } },
      status.component.lsp { lsp_progress = false, surround = { separator = "right" } },
      {
        status.component.builder {
          { provider = require("astroui").get_icon "FolderClosed" },
          padding = { right = 1 },
          hl = status.hl.get_attributes("mode", true),
          surround = { separator = "right", color = "folder_icon_bg" },
        },
        status.component.file_info {
          filename = { fname = function(nr) return vim.fn.getcwd(nr) end, padding = { left = 1 } },
          filetype = false,
          hl = status.hl.get_attributes("mode", true),
          file_icon = false,
          file_modified = false,
          file_read_only = false,
          surround = { separator = "none", color = "folder_bg", condition = false },
        },
      },
      {
        status.component.builder {
          { provider = " ", },
          padding = { right = 1 },
          hl = status.hl.get_attributes("mode", true),
          surround = { separator = "right", color = { main = "word_file_icon_bg", left = "folder_bg" } },
        },
        status.component.builder { --󰷾
          { provider = status.provider.file_encoding() },
          hl = { fg = status.hl.get_attributes("mode", false).fg },
          surround = { separator = "none", color = "word_file_bg", condition = false },
        },
      },
      {
        status.component.builder {
          { provider = require("astroui").get_icon "ScrollText" },
          padding = { right = 1 },
          hl = status.hl.get_attributes("mode", true),
          surround = { separator = "right", color = { main = "scroll_text_icon_bg", left = "word_file_bg" } },
        },
        status.component.nav {
          hl = status.hl.get_attributes("mode", true),
          percentage = { padding = { right = 1 } },
          ruler = false,
          scrollbar = false,
          surround = { separator = "none", color = "scroll_text_bg" },
        },
      },
    }

    opts.winbar = { -- winbar
      init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
      fallthrough = false,
      {
        condition = function() return not status.condition.is_active() end,
        status.component.separated_path { path_func = status.provider.filename { modify = ":.:h" } },
        status.component.file_info {
          file_icon = { hl = status.hl.file_icon "winbar", padding = { left = 0 } },
          filename = {},
          filetype = false,
          file_read_only = false,
          hl = status.hl.get_attributes("winbarnc", true),
          surround = false,
          update = "BufEnter",
        },
      },
      {
        status.component.separated_path(),
        status.component.file_info {
          file_icon = { hl = status.hl.file_icon "winbar", padding = { left = 0 } },
          filename = {},
          filetype = false,
          file_read_only = false,
          hl = status.hl.get_attributes("winbar", true),
          surround = false,
          update = "BufEnter",
        },
        status.component.breadcrumbs(),
      }
    }
    return opts
  end,
}
