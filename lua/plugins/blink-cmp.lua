local trigger_text = ";"
return {
  {
    "saghen/blink.cmp",
    version = not vim.g.lazyvim_blink_main and "*",
    build = vim.g.lazyvim_blink_main and "cargo build --release",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
      "term.sources",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
      "Kaiser-Yang/blink-cmp-avante",
      -- add blink.compat to dependencies
      {
        "saghen/blink.compat",
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = not vim.g.lazyvim_blink_main and "*",
      },
    },
    event = { "InsertEnter", "CmdlineEnter" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = { "buffer", "lsp", "snippets", "path" },
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
            min_keyword_length = function()
              if vim.bo.filetype == "java" then
                return 0
              else
                return 0
              end
            end,
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
      snippets = {
        expand = function(snippet, _)
          return LazyVim.cmp.expand(snippet)
        end,
      },
      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
        kind_icons = {
          Copilot = " ",
          llm = " ",
          Avante = " ",
          AvanteCmd = " ",
          AvanteMention = " ",
        },
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = true } },
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        trigger = {
          prefetch_on_insert = false,
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
      },

      -- experimental signature help support
      signature = {
        enabled = true,
        window = {
          border = "rounded",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        },
      },

      cmdline = {
        enabled = false,
      },
      fuzzy = { implementation = "rust" },

      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
      },
    },
    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      -- setup compat sources
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      -- add ai_accept to <Tab> key
      if not opts.keymap["<Tab>"] then
        if opts.keymap.preset == "super-tab" then -- super-tab
          opts.keymap["<Tab>"] = {
            require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
            LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
            "fallback",
          }
        else -- other presets
          opts.keymap["<Tab>"] = {
            LazyVim.cmp.map({ "snippet_forward", "ai_accept" }),
            "fallback",
          }
        end
      end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
          CompletionItemKind[provider.kind] = kind_idx

          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
              item.kind_icon = LazyVim.config.icons.kinds[item.kind_name] or item.kind_icon or nil
            end
            return items
          end

          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      require("blink.cmp").setup(opts)
    end,
  },

  -- add icons
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.appearance = opts.appearance or {}
      opts.appearance.kind_icons = vim.tbl_extend("force", opts.appearance.kind_icons or {}, LazyVim.config.icons.kinds)
    end,
  },

  -- lazydev
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },
    },
  },
  -- catppuccin support
  {
    "catppuccin",
    optional = true,
    opts = {
      integrations = { blink_cmp = true },
    },
  },
}
