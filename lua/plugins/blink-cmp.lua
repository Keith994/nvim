local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

---@type function?, function?
local icon_provider, hl_provider

local function get_kind_icon(CTX)
  -- Evaluate icon provider
  if not icon_provider then
    local _, mini_icons = pcall(require, "mini.icons")
    if _G.MiniIcons then
      icon_provider = function(ctx)
        local is_specific_color = ctx.kind_hl and ctx.kind_hl:match "^HexColor" ~= nil
        if ctx.item.source_name == "LSP" then
          local icon, hl = mini_icons.get("lsp", ctx.kind or "")
          if icon then
            ctx.kind_icon = icon
            if not is_specific_color then ctx.kind_hl = hl end
          end
        elseif ctx.item.source_name == "Path" then
          ctx.kind_icon, ctx.kind_hl = mini_icons.get(ctx.kind == "Folder" and "directory" or "file", ctx.label)
        end
      end
    end
    if not icon_provider then
      local lspkind_avail, lspkind = pcall(require, "lspkind")
      if lspkind_avail then
        icon_provider = function(ctx)
          if ctx.item.source_name == "LSP" then
            local icon = lspkind.symbolic(ctx.kind, { mode = "symbol" })
            if icon then ctx.kind_icon = icon end
          end
        end
      end
    end
    if not icon_provider then icon_provider = function() end end
  end
  -- Evaluate highlight provider
  if not hl_provider then
    local highlight_colors_avail, highlight_colors = pcall(require, "nvim-colorizer")
    if highlight_colors_avail then
      local kinds
      hl_provider = function(ctx)
        if not kinds then kinds = require("blink.cmp.types").CompletionItemKind end
        if ctx.item.kind == kinds.Color then
          local doc = vim.tbl_get(ctx, "item", "documentation")
          if doc then
            local color_item = highlight_colors_avail and highlight_colors.format(doc, { kind = kinds[kinds.Color] })
            if color_item and color_item.abbr_hl_group then
              if color_item.abbr then ctx.kind_icon = color_item.abbr end
              ctx.kind_hl = color_item.abbr_hl_group
            end
          end
        end
      end
    end
    if not hl_provider then hl_provider = function() end end
  end
  -- Call resolved providers
  icon_provider(CTX)
  hl_provider(CTX)
  -- Return text and highlight information
  return { text = CTX.kind_icon .. CTX.icon_gap, highlight = CTX.kind_hl }
end

local trigger_text = ";"

return {
  {
    "Saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    build = "cargo build --release",
    opts_extend = { "sources.default", "sources.cmdline", "term.sources" },
    dependencies = {
      'Kaiser-Yang/blink-cmp-avante',
    },
    opts = {
      -- remember to enable your providers here
      sources = {
        default = { "buffer", "lsp", "snippets", "path", },
        per_filetype = {
          sql = { "snippets", "dadbod", "buffer" },
          java = { "lsp", "path" },
        },
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            enabled = true,
            max_items = 5,
            score_offset = 100, -- the higher the number, the higher the priority
          },
          lsp = {
            name = "lsp",
            enabled = true,
            module = "blink.cmp.sources.lsp",
            min_keyword_length = function() if vim.bo.filetype == 'java' then return 0 else return 0 end end,
            max_items = 50,
            -- When linking markdown notes, I would get snippets and text in the
            -- suggestions, I want those to show only if there are no LSP
            -- suggestions
            --
            -- Enabled fallbacks as this seems to be working now
            -- Disabling fallbacks as my snippets wouldn't show up when editing
            -- lua files
            fallbacks = { "buffer" },
            score_offset = 90, -- the higher the number, the higher the priority
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = 25,
            -- When typing a path, I would get snippets and text in the
            -- suggestions, I want those to show only if there are no path
            -- suggestions
            fallbacks = { "snippets", "buffer" },
            -- min_keyword_length = 2,
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context)
                return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
              end,
              show_hidden_files_by_default = true,
            },
          },
          buffer = {
            name = "Buffer",
            enabled = true,
            max_items = 5,
            module = "blink.cmp.sources.buffer",
            min_keyword_length = 2,
            score_offset = 15, -- the higher the number, the higher the priority
          },
          snippets = {
            name = "snippets",
            enabled = true,
            max_items = 15,
            min_keyword_length = 2,
            module = "blink.cmp.sources.snippets",
            score_offset = 85, -- the higher the number, the higher the priority
            -- Only show snippets if I type the trigger_text characters, so
            -- to expand the "bash" snippet, if the trigger_text is ";" I have to
            should_show_items = function()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
              -- NOTE: remember that `trigger_text` is modified at the top of the file
              return before_cursor:match(trigger_text .. "%w*$") ~= nil
            end,
            -- After accepting the completion, delete the trigger_text characters
            -- from the final inserted text
            -- Modified transform_items function based on suggestion by `synic` so
            -- that the luasnip source is not reloaded after each transformation
            -- https://github.com/linkarzu/dotfiles-latest/discussions/7#discussion-7849902
            -- NOTE: I also tried to add the ";" prefix to all of the snippets loaded from
            -- friendly-snippets in the luasnip.lua file, but I was unable to do
            -- so, so I still have to use the transform_items here
            -- This removes the ";" only for the friendly-snippets snippets
            transform_items = function(_, items)
              local line = vim.api.nvim_get_current_line()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before_cursor = line:sub(1, col)
              local start_pos, end_pos = before_cursor:find(trigger_text .. "[^" .. trigger_text .. "]*$")
              if start_pos then
                for _, item in ipairs(items) do
                  if not item.trigger_text_modified then
                    ---@diagnostic disable-next-line: inject-field
                    item.trigger_text_modified = true
                    item.textEdit = {
                      newText = item.insertText or item.label,
                      range = {
                        start = { line = vim.fn.line(".") - 1, character = start_pos - 1 },
                        ["end"] = { line = vim.fn.line(".") - 1, character = end_pos },
                      },
                    }
                  end
                end
              end
              return items
            end,
          },
        },
      },
      appearance = {
        kind_icons = {
          Copilot = " ",
          llm = " ",
          Avante = " ",
          AvanteCmd = ' ',
          AvanteMention = ' ',
        },
      },
      keymap = {
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-N>"] = { "select_next", "fallback" },
        ["<C-P>"] = { "select_prev", "fallback" },
        -- ["<C-J>"] = { "select_next", "fallback" },
        -- ["<C-K>"] = { "select_prev", "fallback" },
        ["<C-U>"] = { "scroll_documentation_up", "fallback" },
        ["<C-D>"] = { "scroll_documentation_down", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-J>"] = {
          "select_next",
          "snippet_forward",
          function(cmp)
            if has_words_before() or vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
          end,
          "fallback",
        },
        ["<C-K>"] = {
          "select_prev",
          "snippet_backward",
          "fallback",
        },
        ["<Tab>"] = {
          "select_next",
          "snippet_forward",
          function(cmp)
            if has_words_before() or vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          "select_prev",
          "snippet_backward",
          function(cmp)
            if vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
          end,
          "fallback",
        },
      },
      fuzzy = { implementation = "rust" },
      completion = {
        list = { selection = { preselect = false, auto_insert = true } },
        keyword = {
          range = "prefix",
        },
        ghost_text = { enabled = vim.g.ai_cmp },
        trigger = {
          prefetch_on_insert = false,
        },
        accept = {
          auto_brackets = {
            enabled = true,
            -- Asynchronously use semantic token to determine if brackets should be added
            semantic_token_resolution = {
              enabled = true,
              -- blocked_filetypes = { "java" },
              -- How long to wait for semantic tokens to return before assuming no brackets should be added
              timeout_ms = 100,
            },
          },
          dot_repeat = false,
          create_undo_point = false,
        },
      },
      signature = {
        window = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        },
      },
    },
    specs = {
      {
        "L3MON4D3/LuaSnip",
        optional = true,
        specs = { { "Saghen/blink.cmp", opts = { snippets = { preset = "luasnip" } } } },
      },
      {
        "folke/lazydev.nvim",
        optional = true,
        specs = {
          {
            "Saghen/blink.cmp",
            opts = function(_, opts)
              if pcall(require, "lazydev.integrations.blink") then
                return require("astrocore").extend_tbl(opts, {
                  sources = {
                    -- add lazydev to your completion providers
                    default = { "lazydev" },
                    providers = {
                      lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
                    },
                  },
                })
              end
            end,
          },
        },
      },
      {
        "catppuccin",
        optional = true,
        ---@type CatppuccinOptions
        opts = { integrations = { blink_cmp = true } },
      },
    },
  },
}
