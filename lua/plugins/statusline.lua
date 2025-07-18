return {
  {
    "rebelot/heirline.nvim",
    event = "BufEnter",
    dependencies = {
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
          require("heirline-components.core.env").separators = utils.extend_tbl(sep, require("util.icons").separators)
        end,
      },
    },
    opts = function()
      local lib = require("heirline-components.all")
      -- local function bufnr(opts)
      --   opts = utils.extend_tbl({}, opts)
      --   return function(self)
      --     return lib.utils.stylize(
      --       tostring(self and self.bufnr or vim.api.nvim_get_current_buf()) .. (opts.suffix or " "),
      --       opts
      --     )
      --   end
      -- end
      -- local tabline_buffers = function(opts)
      --   local hl = lib.hl
      --   local condition = lib.condition
      --   local buf_utils = require("heirline-components.buffer")
      --   local extend_tbl = utils.extend_tbl
      --
      --   local file_info_table = lib.component.file_info(extend_tbl({
      --     file_icon = {
      --       condition = function(self)
      --         return not self._show_picker
      --       end,
      --       hl = hl.file_icon("tabline"),
      --     },
      --     filename = {},
      --     filetype = false,
      --     file_modified = {
      --       padding = { left = 1, right = 1 },
      --       condition = condition.is_file,
      --     },
      --     unique_path = {
      --       hl = function(self)
      --         return hl.get_attributes(self.tab_type .. "_path")
      --       end,
      --     },
      --     close_button = {
      --       hl = function(self)
      --         return hl.get_attributes(self.tab_type .. "_close")
      --       end,
      --       padding = { left = 1, right = 1 },
      --       on_click = {
      --         callback = function(_, minwid)
      --           buf_utils.close(minwid)
      --         end,
      --         minwid = function(self)
      --           return self.bufnr
      --         end,
      --         name = "heirline_tabline_close_buffer_callback",
      --       },
      --     },
      --     padding = { left = 1, right = 1 },
      --     hl = function(self)
      --       local tab_type = self.tab_type
      --       if self._show_picker and self.tab_type ~= "buffer_active" then
      --         tab_type = "buffer_visible"
      --       end
      --       return hl.get_attributes(tab_type)
      --     end,
      --     surround = false,
      --   }, opts))
      --
      --   table.insert(file_info_table, 3, {
      --     provider = bufnr({ suffix = ":" }),
      --   })
      --
      --   return require("heirline-components.core.heirline").make_buflist(file_info_table)
      -- end

      -- local path_func = lib.provider.filename({ modify = ":.:h", fallback = "" })
      return {
        statusline = {
          hl = { fg = "fg", bg = "bg" },
          lib.component.mode({
            mode_text = { icon = { kind = "VimIcon", padding = { right = 0, left = 1 } } },
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
        --stylua: ignore
        -- winbar = {
        --   init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
        --   fallthrough = false,
        --   {
        --     condition = function() return not lib.condition.is_active() end,
        --     lib.component.separated_path(),
        --     lib.component.file_info {
        --       file_icon = { hl = lib.hl.file_icon "winbar", padding = { left = 0 } },
        --       filename = {},
        --       filetype = false,
        --       file_read_only = false,
        --       hl = lib.hl.get_attributes("winbarnc", true),
        --       surround = false,
        --       update = { "BufEnter", "BufFilePost" },
        --     },
        --   },
        --   -- active winbar
        --   {
        --     -- show the path to the file relative to the working directory
        --     lib.component.separated_path { path_func = path_func },
        --     -- add the file name and icon
        --     lib.component.file_info { -- add file_info to breadcrumbs
        --       file_icon = { hl = lib.hl.filetype_color, padding = { left = 0 } },
        --       filename = {},
        --       filetype = false,
        --       file_modified = false,
        --       file_read_only = false,
        --       hl = lib.hl.get_attributes("winbar", true),
        --       surround = false,
        --       update = "BufEnter",
        --     },
        --     -- show the breadcrumbs
        --     lib.component.breadcrumbs {
        --       icon = { hl = true },
        --       hl = lib.hl.get_attributes("winbar", true),
        --       prefix = true,
        --       padding = { left = 0 },
        --     },
        --   },
        -- },
        -- tabline = {
        --   lib.component.tabline_conditional_padding(),
        --   tabline_buffers(),
        --   lib.component.fill({ hl = { bg = "tabline_bg" } }), -- fill the rest of the tabline with background color
        --   lib.component.tabline_tabpages(),
        -- },
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

  {
    "Bekaboo/dropbar.nvim",
    event = "UIEnter",
    opts = {
      sources = {
        path = {
          max_depth = 1,
        },
      },
    },
    specs = {
      {
        "rebelot/heirline.nvim",
        optional = true,
        opts = function(_, opts)
          opts.winbar = nil
        end,
      },
      {
        "catppuccin",
        optional = true,
        opts = { integrations = { dropbar = { enabled = true } } },
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete Buffers to the Left" },
      { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
      { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
      { "<b",         "<cmd>BufferLineMovePrev<cr>",             desc = "Move buffer prev" },
      { ">B",         "<cmd>BufferLineMoveNext<cr>",             desc = "Move buffer next" },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) Snacks.bufdelete(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("util.icons")
          local ret = (diag.error and icons.diagnostics.Error .. diag.error .. " " or "")
              .. (diag.warning and icons.diagnostics.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
          {
            filetype = "snacks_layout_box",
          },
        },
        ---@param opts bufferline.IconFetcherOpts
        get_element_icon = function(opts)
          local icons = require("util.icons")
          return icons.ft[opts.filetype]
        end,
        numbers = function(opts)
          return string.format("%s", opts.id)
        end,
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
}
