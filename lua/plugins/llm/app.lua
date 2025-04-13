local prompts = require("plugins.llm.prompts")
local tools = require("llm.tools")
return {
  app_handler = {
    OptimizeCode = {
      handler = tools.side_by_side_handler,
      opts = {
        -- streaming_handler = local_llm_streaming_handler,
        left = {
          focusable = false,
        },
      },
    },
    TestCode = {
      handler = tools.side_by_side_handler,
      prompt = prompts.TestCode,
      opts = {
        right = {
          title = " Test Cases ",
        },
      },
    },
    OptimCompare = {
      handler = tools.action_handler,
      opts = {
        fetch_key = function()
          return vim.env.GITHUB_TOKEN
        end,
        url = "https://models.inference.ai.azure.com/chat/completions",
        model = "gpt-4o-mini",
        api_type = "openai",
        language = "Chinese",
      },
    },

    DocString = {
      prompt = prompts.DocString,
      handler = tools.action_handler,
      opts = {
        fetch_key = function()
          return vim.env.GITHUB_TOKEN
        end,
        url = "https://models.inference.ai.azure.com/chat/completions",
        model = "gpt-4o-mini",
        api_type = "openai",
        only_display_diff = true,
        templates = {
          lua = [[- For the Lua language, you should use the LDoc style.
- Start all comment lines with "---".]],
          python = [[- For the python language, you should use the numpy style.]],
        },
      },
    },
    Translate = {
      handler = tools.qa_handler,
      opts = {
        fetch_key = function()
          return vim.env.GLM_KEY
        end,
        url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
        model = "glm-4-flash",
        api_type = "zhipu",

        component_width = "60%",
        component_height = "50%",
        query = {
          title = " 󰊿 Trans ",
          hl = { link = "Define" },
        },
        input_box_opts = {
          size = "15%",
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
        preview_box_opts = {
          size = "85%",
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
          },
        },
      },
    },

    -- check siliconflow's balance
    UserInfo = {
      handler = function()
        local key = os.getenv("LLM_KEY")
        local res = tools.curl_request_handler(
          "https://api.siliconflow.cn/v1/user/info",
          { "GET", "-H", string.format("'Authorization: Bearer %s'", key) }
        )
        if res ~= nil then
          print("balance: " .. res.data.balance)
        end
      end,
    },
    WordTranslate = {
      handler = tools.flexi_handler,
      prompt = prompts.WordTranslate,
      -- prompt = "Translate the following text to English, please only return the translation",
      opts = {
        fetch_key = function()
          return vim.env.GLM_KEY
        end,
        url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
        model = "glm-4-flash",
        api_type = "zhipu",
        win_opts = {
          zindex = 120,
        },
        -- args = [=[return string.format([[curl %s -N -X POST -H "Content-Type: application/json" -H "Authorization: Bearer %s" -d '%s']], url, LLM_KEY, vim.fn.json_encode(body))]=],
        -- args = [[return {url, "-N", "-X", "POST", "-H", "Content-Type: application/json", "-H", authorization, "-d", vim.fn.json_encode(body)}]],
        exit_on_move = true,
        enter_flexible_window = false,
      },
    },
    CodeExplain = {
      handler = tools.flexi_handler,
      prompt = prompts.CodeExplain,
      opts = {
        fetch_key = function()
          return vim.env.GLM_KEY
        end,
        url = "https://open.bigmodel.cn/api/paas/v4/chat/completions",
        model = "glm-4-flash",
        api_type = "zhipu",
        enter_flexible_window = true,
      },
    },
    CommitMsg = {
      handler = tools.flexi_handler,
      prompt = prompts.CommitMsg,

      opts = {
        fetch_key = function()
          return vim.env.CHAT_ANYWHERE_KEY
        end,
        url = "https://api.chatanywhere.tech/v1/chat/completions",
        model = "gpt-4o-mini",
        api_type = "openai",
        enter_flexible_window = true,
        apply_visual_selection = false,
        win_opts = {
          relative = "editor",
          position = "50%",
          zindex = 100,
        },
        accept = {
          mapping = {
            mode = "n",
            keys = "<cr>",
          },
          action = function()
            local contents = vim.api.nvim_buf_get_lines(0, 0, -1, true)
            vim.api.nvim_command(string.format('!git commit -m "%s"', table.concat(contents, '" -m "')))

            -- just for lazygit
            vim.schedule(function()
              vim.api.nvim_command("LazyGit")
            end)
          end,
        },
      },
    },
    Ask = {
      handler = tools.disposable_ask_handler,
      opts = {
        position = {
          row = 2,
          col = 0,
        },
        title = " Ask ",
        inline_assistant = true,
        language = "Chinese",
        url = "https://api.chatanywhere.tech/v1/chat/completions",
        model = "gpt-4o-mini",
        api_type = "openai",
        fetch_key = function()
          return vim.env.CHAT_ANYWHERE_KEY
        end,
        display = {
          mapping = {
            mode = "n",
            keys = { "d" },
          },
          action = nil,
        },
        accept = {
          mapping = {
            mode = "n",
            keys = { "Y", "y" },
          },
          action = nil,
        },
        reject = {
          mapping = {
            mode = "n",
            keys = { "N", "n" },
          },
          action = nil,
        },
        close = {
          mapping = {
            mode = "n",
            keys = { "<esc>" },
          },
          action = nil,
        },
      },
    },
    AttachToChat = {
      handler = tools.attach_to_chat_handler,
      opts = {
        is_codeblock = true,
        inline_assistant = true,
        language = "Chinese",
      },
    },

    Completion = {
      handler = tools.completion_handler,
      opts = {
        -------------------------------------------------
        ---                  ollama
        -------------------------------------------------
        -- url = "http://localhost:11434/api/generate",
        url = "http://localhost:11434/v1/completions",
        model = "qwen2.5-coder:1.5b",
        api_type = "ollama",

        -------------------------------------------------
        ---                 deepseek
        -------------------------------------------------
        -- url = "https://api.deepseek.com/beta/completions",
        -- model = "deepseek-chat",
        -- api_type = "deepseek",
        -- fetch_key = function()
        --   return vim.env.DEEPSEEK_TOKEN
        -- end,

        -------------------------------------------------
        ---                 siliconflow
        -------------------------------------------------
        -- url = "https://api.siliconflow.cn/v1/completions",
        -- model = "Qwen/Qwen2.5-Coder-7B-Instruct",
        -- api_type = "openai",
        -- fetch_key = function()
        --   return vim.env.SILICONFLOW_TOKEN
        -- end,
        -------------------------------------------------
        ---                 codeium
        -------------------------------------------------
        -- api_type = "codeium",

        n_completions = 1,
        context_window = 16000,
        max_tokens = 256,
        keep_alive = -1,
        filetypes = {
          sh = false,
          zsh = false,
        },
        timeout = 10,
        default_filetype_enabled = true,
        auto_trigger = true,
        only_trigger_by_keywords = true,
        style = "blink.cmp",
        -- style = "nvim-cmp",
        -- style = "virtual_text",
        keymap = {
          virtual_text = {
            accept = {
              mode = "i",
              keys = "<A-a>",
            },
            next = {
              mode = "i",
              keys = "<A-n>",
            },
            prev = {
              mode = "i",
              keys = "<A-p>",
            },
            toggle = {
              mode = "n",
              keys = "<leader>cp",
            },
          },
        },
      },
    },
  },
}
