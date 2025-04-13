return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    animate = {
      enabled = true,
      style = "out",
      duration = 30,
      easing = 'linear',
      fps = 60,
    },
    indent = {
      animate = {
        enabled = true,
      }
    },
    dim = {
      scope = {
        min_size = 5,
        max_size = 20,
        siblings = true,
      },
      -- animate scopes. Enabled by default for Neovim >= 0.10
      -- Works on older versions but has to trigger redraws during animation.
      ---@type snacks.animate.Config|{enabled?: boolean}
      animate = {
        enabled = true,
        easing = "outQuad",
        duration = {
          step = 30,   -- ms per step
          total = 300, -- maximum duration
        },
      },
      -- what buffers to animate
      filter = function(buf)
        return vim.g.snacks_dim ~= false and vim.bo[buf].buftype ~= "terminal"
      end,
    },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 30, total = 300 },
        easing = "linear",
      },
      -- faster animation when repeating scroll after delay
      animate_repeat = {
        delay = 100, -- delay in ms before using the repeat animation
        duration = { step = 30, total = 300 },
        easing = "linear",
      },
      -- what buffers to animate
      filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.bo[buf].buftype ~= "terminal"
      end,
    },
    picker = {
      ui_select = true,
      layout = {
        preset = "ivy",
        cycle = false,
      },
      layouts = {
        ivy = {
          layout = {
            box = "vertical",
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.5,
            border = "top",
            title = " {title} {live} {flags}",
            title_pos = "left",
            { win = "input", height = 1, border = "bottom" },
            {
              box = "horizontal",
              { win = "list",    border = "none" },
              { win = "preview", title = "{preview}", width = 0.5, border = "left" },
            },
          }
        },
        vertical = {
          layout = {
            backdrop = false,
            width = 0.8,
            min_width = 80,
            height = 0.8,
            min_height = 30,
            box = "vertical",
            border = "rounded",
            title = "{title} {live} {flags}",
            title_pos = "center",
            { win = "input",   height = 1,          border = "bottom" },
            { win = "list",    border = "none" },
            { win = "preview", title = "{preview}", height = 0.4,     border = "top" },
          },
        },
      },
      matcher = {
        frecency = true,
      },
      win = {
        input = {
          keys = {
            -- to close the picker on ESC instead of going to normal mode,
            -- add the following keymap to your config
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<C-g>"] = { "close", mode = { "n", "i" } },
            ["<C-l>"] = { "toggle_live", mode = { "n", "i" } },
            -- I'm used to scrolling like this in LazyGit
            -- ["J"] = { "preview_scroll_down", mode = { "i", "n" } },
            -- ["K"] = { "preview_scroll_up", mode = { "i", "n" } },
            -- ["H"] = { "preview_scroll_left", mode = { "i", "n" } },
            -- ["L"] = { "preview_scroll_right", mode = { "i", "n" } },
          },
        },
      },
      formatters = {
        file = {
          filename_first = true, -- display filename before the file path
          truncate = 80,
        },
      },
    },
    notifier = { enabled = true },
    -- Folke pointed me to the snacks docs
    -- https://github.com/LazyVim/LazyVim/discussions/4251#discussioncomment-11198069
    -- Here's the lazygit snak docs
    -- https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md
    lazygit = {
      configure = true,
      -- theme = {
      --   selectedLineBgColor = { bg = "CursorLine" },
      -- },
      config = {
        os = { editPreset = "nvim-remote" },
        gui = {
          nerdFontsVersion = "3",
        }
      },
      theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
      -- Theme for lazygit
      theme = {
        [241]                      = { fg = "Special" },
        activeBorderColor          = { fg = "MatchParen", bold = true },
        cherryPickedCommitBgColor  = { fg = "Identifier" },
        cherryPickedCommitFgColor  = { fg = "Function" },
        defaultFgColor             = { fg = "Normal" },
        inactiveBorderColor        = { fg = "FloatBorder" },
        optionsTextColor           = { fg = "Function" },
        searchingActiveBorderColor = { fg = "MatchParen", bold = true },
        selectedLineBgColor        = { bg = "Visual" }, -- set to `default` to have no background colour
        unstagedChangesColor       = { fg = "DiagnosticError" },
      },
      win = {
        -- style = "lazygit",
        width = 0,
        height = 0,
      },
    },
  },
}
