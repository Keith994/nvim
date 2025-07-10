return {
  {
    "rebelot/heirline.nvim",
    event = "VimEnter",
    dependencies = { "echasnovski/mini.icons" },
    specs = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          opts.autocmds.heirline_colors = {
            {
              event = "User",
              pattern = "AstroColorScheme",
              desc = "Refresh heirline colors",
              callback = function()
                if package.loaded["heirline"] then
                  require("astroui.status.heirline").refresh_colors()
                end
              end,
            },
          }
        end,
      },
    },
    opts = function(_, opts)
      local status = require("astroui.status")
      local ui_config = require("astroui").config
      local cached_func = function(func, ...)
        local cached
        local args = { ... }
        return function(self)
          if cached == nil then
            cached = func(unpack(args))
          end
          if type(cached) == "function" then
            return cached(self)
          end
          return cached
        end
      end
      return require("astrocore").extend_tbl(opts, {
        opts = {
          colors = require("astroui").config.status.setup_colors(),
          disable_winbar_cb = function(args)
            local enabled = vim.tbl_get(ui_config, "status", "winbar", "enabled")
            if enabled and status.condition.buffer_matches(enabled, args.buf) then
              return false
            end
            local disabled = vim.tbl_get(ui_config, "status", "winbar", "disabled")
            return not require("astrocore.buffer").is_valid(args.buf)
              or (disabled and status.condition.buffer_matches(disabled, args.buf))
          end,
        },
        statusline = { -- statusline
          hl = { fg = "fg", bg = "bg" },
          status.component.mode({
            mode_text = { icon = { kind = "VimIcon", padding = { right = 1, left = 1 } } },
            surround = {
              separator = "left",
              color = lib.hl.mode_bg,
              update = {
                "ModeChanged",
                pattern = "*:*",
              },
            },
          }),
          status.component.file_info({
            filetype = false,
            filename = {},
            surround = {
              separator = "left",
            },
          }),
          status.component.git_branch(),
          status.component.git_diff(),
          status.component.diagnostics(),
          status.component.fill(),
          status.component.cmd_info({ lsp_progress = false }),
          status.component.lsp(),
          status.component.builder(status.setup_providers({
            ruler = {},
            percentage = { padding = { left = 1, right = 1 } },
            surround = { separator = "right", color = "nav_bg" },
            hl = status.hl.get_attributes("nav"),
            update = { "CursorMoved", "CursorMovedI", "BufEnter" },
          }, { "ruler", "percentage" })),
          status.component.file_info({
            filename = {
              fallback = "",
              fname = function(nr)
                local buf_enc = vim.bo[vim.api.nvim_get_current_buf() or 0].fenc
                buf_enc = string.upper(buf_enc ~= "" and buf_enc or vim.o.enc)
                return vim.fn.getcwd(nr) .. " <" .. buf_enc .. ">"
              end,
              padding = { left = 1, right = 1 },
            },
            filetype = false,
            hl = status.hl.get_attributes("mode"),
            file_icon = false,
            file_modified = false,
            file_read_only = false,
            surround = {
              separator = "right",
              color = status.hl.mode_bg,
              update = {
                "ModeChanged",
                pattern = "*:*",
              },
            },
          }),
        },
        winbar = { -- winbar
          init = function(self)
            self.bufnr = vim.api.nvim_get_current_buf()
          end,
          fallthrough = false,
          {
            condition = function()
              return not status.condition.is_active()
            end,
            status.component.separated_path(),
            status.component.file_info({
              file_icon = { hl = cached_func(status.hl.file_icon, "winbar"), padding = { left = 0 } },
              filename = {},
              filetype = false,
              file_read_only = false,
              hl = cached_func(status.hl.get_attributes, "winbarnc", true),
              surround = false,
              update = { "BufEnter", "BufFilePost" },
            }),
          },
          status.component.breadcrumbs({ hl = cached_func(status.hl.get_attributes, "winbar", true) }),
        },
        tabline = { -- bufferline
          { -- automatic sidebar padding
            condition = function(self)
              self.winid = vim.api.nvim_tabpage_list_wins(0)[1]
              self.winwidth = vim.api.nvim_win_get_width(self.winid)
              return self.winwidth ~= vim.o.columns -- only apply to sidebars
                and not require("astrocore.buffer").is_valid(vim.api.nvim_win_get_buf(self.winid)) -- if buffer is not in tabline
            end,
            provider = function(self)
              return (" "):rep(self.winwidth + 1)
            end,
            hl = { bg = "tabline_bg" },
          },
          status.heirline.make_buflist(status.component.tabline_file_info()), -- component for each buffer tab
          status.component.fill({ hl = { bg = "tabline_bg" } }), -- fill the rest of the tabline with background color
          { -- tab list
            condition = function()
              return #vim.api.nvim_list_tabpages() >= 2
            end, -- only show tabs if there are more than one
            status.heirline.make_tablist({ -- component for each tab
              provider = status.provider.tabnr(),
              hl = function(self)
                return status.hl.get_attributes(status.heirline.tab_type(self, "tab"), true)
              end,
            }),
            { -- close button for current tab
              provider = status.provider.close_button({ kind = "TabClose", padding = { left = 1, right = 1 } }),
              hl = cached_func(status.hl.get_attributes, "tab_close", true),
              on_click = {
                callback = function()
                  require("astrocore.buffer").close_tab()
                end,
                name = "heirline_tabline_close_tab_callback",
              },
            },
          },
        },
        statuscolumn = {
          init = function(self)
            self.bufnr = vim.api.nvim_get_current_buf()
          end,
          status.component.foldcolumn(),
          status.component.numbercolumn(),
          status.component.signcolumn(),
        },
      })
    end,
  },
}
