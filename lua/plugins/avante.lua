local prefix = "<Leader>a"
return {
  "yetone/avante.nvim",
  -- build = vim.fn.has("win32") == 1 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
  --   or "make",
  event = "BufReadPost", -- load on file open because Avante manages it's own bindings
  cmd = {
    "AvanteAsk",
    "AvanteBuild",
    "AvanteEdit",
    "AvanteRefresh",
    "AvanteSwitchProvider",
    "AvanteShowRepoMap",
    "AvanteModels",
    "AvanteChat",
    "AvanteToggle",
    "AvanteClear",
    "AvanteFocus",
    "AvanteStop",
  },
  dependencies = {
    { "stevearc/dressing.nvim", optional = true },
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    provider = "copilot",
    -- provider = "openrouter",
    -- auto_suggestions_provider = "openrouter",
    suggestion = {
      debounce = 800,
      throttle = 800,
    },
    providers = {
      openrouter = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "google/gemini-2.5-flash",
        -- model = 'openai/gpt-4o-mini',
        -- model = 'google/gemini-2.5-pro-preview-03-25',
        -- model = 'x-ai/grok-3-beta',
      },
    },
    behaviour = {
      auto_suggestions = false, -- Experimental stage
      -- auto_set_highlight_group = true,
      -- auto_set_keymaps = true,
      -- auto_apply_diff_after_generation = false,
      -- support_paste_from_clipboard = false,
      -- minimize_diff = true,                  -- Whether to remove unchanged lines when applying a code block
      -- enable_token_counting = true,          -- Whether to enable token counting. Default to true.
      -- auto_approve_tool_permissions = false, -- Default: show permission prompts for all tools
      -- Examples:
      -- auto_approve_tool_permissions = true,                -- Auto-approve all tools (no prompts)
      -- auto_approve_tool_permissions = {"bash", "replace_in_file"}, -- Auto-approve specific tools only
    },
    input = {
      provider = "snacks",
      provider_opts = {
        -- Additional snacks.input options
        title = "Avante Input",
        icon = " ",
      },
    },
    mappings = {
      ask = prefix .. "<CR>",
      new_ask = prefix .. "n",
      edit = prefix .. "e",
      refresh = prefix .. "r",
      focus = prefix .. "f",
      select_model = prefix .. "?",
      stop = prefix .. "S",
      select_history = prefix .. "h",
      toggle = {
        default = prefix .. "t",
        debug = prefix .. "d",
        hint = prefix .. "h",
        suggestion = prefix .. "s",
        repomap = prefix .. "R",
      },
      diff = {
        next = "]c",
        prev = "[c",
      },
      files = {
        add_current = prefix .. ".",
        add_all_buffers = prefix .. "B",
      },
      cancel = {
        normal = { "<C-c>", "<C-g>", "<Esc>", "q" },
        insert = { "<C-c>", "<C-g>" },
      },
      sidebar = {
        apply_all = "A",
        apply_cursor = "a",
        retry_user_request = "r",
        edit_user_request = "e",
        switch_windows = "<Tab>",
        reverse_switch_windows = "<S-Tab>",
        remove_file = "d",
        add_file = "@",
        close = { "<Esc>", "q" },
        close_from_input = { insert = "<C-g>" }, -- 例如，{ normal = "<Esc>", insert = "<C-d>" }
      },
    },
  },
  specs = { -- configure optional plugins
    {
      "folke/which-key.nvim",
      optional = true,
      opts = function(_, opts)
        return utils.extend_tbl(opts, {
          spec = {
            {
              { "<leader>a", group = "avante", icon = { icon = " " } },
            },
          },
        })
      end,
    },
    { -- if copilot.lua is available, default to copilot provider
      "zbirenbaum/copilot.lua",
      optional = true,
      specs = {
        {
          "yetone/avante.nvim",
          opts = {
            -- provider = "copilot",
            -- auto_suggestions_provider = "copilot",
          },
        },
      },
    },
    {
      -- make sure `Avante` is added as a filetype
      "MeanderingProgrammer/render-markdown.nvim",
      optional = true,
      opts = function(_, opts)
        if not opts.file_types then
          opts.file_types = { "markdown" }
        end
        opts.file_types = utils.list_insert_unique(opts.file_types, { "Avante" })
      end,
    },
    {
      -- make sure `Avante` is added as a filetype
      "OXY2DEV/markview.nvim",
      optional = true,
      opts = function(_, opts)
        if not opts.filetypes then
          opts.filetypes = { "markdown", "quarto", "rmd" }
        end
        opts.filetypes = utils.list_insert_unique(opts.filetypes, { "Avante" })
      end,
    },
    {
      "folke/snacks.nvim",
      optional = true,
      specs = {
        {
          "yetone/avante.nvim",
          opts = {
            selector = {
              provider = "snacks",
            },
          },
        },
      },
    },
  },
}
