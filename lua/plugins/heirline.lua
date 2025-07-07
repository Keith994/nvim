return {
  {
    "rebelot/heirline.nvim",
    event = "VimEnter",
    dependencies = {
      {
        "echasnovski/mini.icons",
        {
          "Zeioth/heirline-components.nvim",
          opts = function()
            local icons = require("util.icons")
            local ret = {
              icons = {
                DiagnosticError = icons.diagnostics.Error,
                DiagnosticHint = icons.diagnostics.Hint,
                DiagnosticInfo = icons.diagnostics.Info,
                DiagnosticWarn = icons.diagnostics.Warn,
                PathSeparator = icons.misc.separator,

                GitBranch = icons.git.branch,
                GitAdd = icons.git.added,
                GitChange = icons.git.modified,
                GitDelete = icons.git.removed,
                BreadcrumbSeparator = icons.misc.separator,
                VimIcon = icons.misc.VimIcon,
              },
            }
            return ret
          end,
          config = function(_, opts)
            require("heirline-components").setup(opts)
            -- injects custom icon
            local sep = require("heirline-components.core.env").separators
            require("heirline-components.core.env").separators =
              utils.extend_tbl(sep, require("util.icons").separators)
          end,
        },
      },
    },
    opts = function()
      local lib = require("heirline-components.all")
      local function bufnr(opts)
        opts = utils.extend_tbl({}, opts)
        return function(self)
          return lib.utils.stylize(
            tostring(self and self.bufnr or vim.api.nvim_get_current_buf()) .. (opts.suffix or " "),
            opts
          )
        end
      end
      local tabline_buffers = function(opts)
        local hl = lib.hl
        local condition = lib.condition
        local buf_utils = require("heirline-components.buffer")
        local extend_tbl = utils.extend_tbl

        local file_info_table = lib.component.file_info(extend_tbl({
          file_icon = {
            condition = function(self)
              return not self._show_picker
            end,
            hl = hl.file_icon("tabline"),
          },
          filename = {},
          filetype = false,
          file_modified = {
            padding = { left = 1, right = 1 },
            condition = condition.is_file,
          },
          unique_path = {
            hl = function(self)
              return hl.get_attributes(self.tab_type .. "_path")
            end,
          },
          close_button = {
            hl = function(self)
              return hl.get_attributes(self.tab_type .. "_close")
            end,
            padding = { left = 1, right = 1 },
            on_click = {
              callback = function(_, minwid)
                buf_utils.close(minwid)
              end,
              minwid = function(self)
                return self.bufnr
              end,
              name = "heirline_tabline_close_buffer_callback",
            },
          },
          padding = { left = 1, right = 1 },
          hl = function(self)
            local tab_type = self.tab_type
            if self._show_picker and self.tab_type ~= "buffer_active" then
              tab_type = "buffer_visible"
            end
            return hl.get_attributes(tab_type)
          end,
          surround = false,
        }, opts))

        table.insert(file_info_table, 3, {
          provider = bufnr({ suffix = ":" }),
        })

        return require("heirline-components.core.heirline").make_buflist(file_info_table)
      end
      return {
        statusline = {
          hl = { fg = "fg", bg = "bg" },
          lib.component.mode({
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
          lib.component.file_info({
            filetype = false,
            filename = {},
            surround = {
              separator = "left",
            },
          }),
          lib.component.git_branch(),
          lib.component.git_diff(),
          lib.component.diagnostics(),
          lib.component.fill(),
          lib.component.cmd_info(),
          lib.component.lsp({ lsp_progress = false }),
          lib.component.builder(lib.utils.setup_providers({
            ruler = {},
            percentage = { padding = { left = 1, right = 1 } },
            surround = { separator = "right", color = "nav_bg" },
            hl = lib.hl.get_attributes("nav"),
            update = { "CursorMoved", "CursorMovedI", "BufEnter" },
          }, { "ruler", "percentage" })),
          lib.component.file_info({
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
            hl = lib.hl.get_attributes("mode"),
            file_icon = false,
            file_modified = false,
            file_read_only = false,
            surround = {
              separator = "right",
              color = lib.hl.mode_bg,
              update = {
                "ModeChanged",
                pattern = "*:*",
              },
            },
          }),
        },
        tabline = {
          lib.component.tabline_conditional_padding(),
          tabline_buffers(),
          lib.component.fill({ hl = { bg = "tabline_bg" } }), -- fill the rest of the tabline with background color
          lib.component.tabline_tabpages(),
        },
        statuscolumn = {
          init = function(self)
            self.bufnr = vim.api.nvim_get_current_buf()
          end,
          lib.component.foldcolumn(),
          lib.component.numbercolumn(),
          lib.component.signcolumn(),
        },
      }
    end,
    config = function(_, opts)
      local heirline = require("heirline")
      local lib = require("heirline-components.all")

      -- Setup
      lib.init.subscribe_to_events()
      heirline.load_colors(lib.hl.get_colors())
      heirline.setup(opts)
    end,
  },
}
