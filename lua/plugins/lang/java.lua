function get_raw_config(server)
  local ok, ret = pcall(require, "lspconfig.configs." .. server)
  if ok then
    return ret
  end
  return require("lspconfig.server_configurations." .. server)
end

-- This is the same as in lspconfig.configs.jdtls, but avoids
-- needing to require that when this module loads.
local java_filetypes = { "java" }

-- Utility function to extend or override a config table, similar to the way
-- that Plugin.opts works.
---@param config table
---@param custom function | table | nil
local function extend_or_override(config, custom, ...)
  if type(custom) == "function" then
    config = custom(config, ...) or config
  elseif custom then
    config = vim.tbl_deep_extend("force", config, custom) --[[@as table]]
  end
  return config
end

return {
  -- Add java to treesitter.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "java" } },
  },

  -- Ensure java debugger and test packages are installed.
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      -- Simple configuration to attach to remote java debug process
      -- Taken directly from https://github.com/mfussenegger/nvim-dap/wiki/Java
      local dap = require("dap")
      dap.configurations.java = {
        {
          type = "java",
          request = "attach",
          name = "Debug (Attach) - Remote",
          hostName = "127.0.0.1",
          port = 5005,
        },
      }
    end,
    dependencies = {
      "mason-org/mason.nvim",
    },
  },

  -- Configure nvim-lspconfig to install the server automatically via mason, but
  -- defer actually starting it to our configuration of nvim-jtdls below.
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function(_, opts)
      return utils.extend_tbl(opts, {
        -- make sure mason installs the server
        servers = {
          jdtls = {},
        },
        setup = {
          jdtls = function()
            return true -- avoid duplicate servers
          end,
        },
        ensure_installed = { "java-debug-adapter", "java-test", "google-java-format" },
      })
    end,
  },

  -- Set up nvim-jdtls to attach to java files.
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "folke/which-key.nvim" },
    ft = java_filetypes,
    opts = function()
      local cmd = {
        "/usr/lib/jvm/java-21-openjdk/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        -- "-Dlog:disable",
        -- "-Djdt.ls.debug=false",
        "-Dlombok.disableConfig=true",
        "-javaagent:" .. vim.fn.expand("$MASON/share/jdtls/lombok.jar"),
        "-Dsun.zip.disableMemoryMapping=true",
        "-Xms1g",             -- 初始堆内存提升
        "-Xmx8g",             -- 最大堆内存提升
        "-XX:+UseParallelGC", -- 启用 G1 GC
        "-XX:GCTimeRatio=4",  -- 启用 G1 GC
        "-XX:+ParallelRefProcEnabled",
        "-XX:AdaptiveSizePolicyWeight=90",
        "-XX:+UseStringDeduplication",
        "-XX:MaxGCPauseMillis=200", -- 优化 GC 停顿
        "-XX:MetaspaceSize=1G",     -- Metaspace 初始大小
        "-XX:MaxMetaspaceSize=2G",  -- 限制 Metaspace 上限

        "-XX:+UnlockExperimentalVMOptions",
        "-XX:G1NewSizePercent=20",
        "-XX:InitiatingHeapOccupancyPercent=35",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        vim.fn.expand("$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher_1.7.0.v20250331-1702.jar"),
        "-configuration",
        vim.fn.expand("$MASON/share/jdtls/config"),
      }
      return {
        -- How to find the root dir for a given filename. The default comes from
        -- lspconfig which provides a function specifically for java projects.
        root_dir = get_raw_config("jdtls").default_config.root_dir,

        -- How to find the project name for a given root dir.
        project_name = function(root_dir)
          return root_dir and vim.fs.basename(root_dir)
        end,

        -- Where are the config and workspace dirs for a project?
        jdtls_config_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
        end,
        jdtls_workspace_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
        end,

        -- How to run jdtls. This can be overridden to a full java command-line
        -- if the Python wrapper script doesn't suffice.
        cmd = cmd,
        full_cmd = function(opts)
          local fname = vim.api.nvim_buf_get_name(0)
          local root_dir = opts.root_dir(fname)
          local project_name = opts.project_name(root_dir)
          local cmd1 = vim.deepcopy(opts.cmd)
          if project_name then
            vim.list_extend(cmd1, {
              -- "-configuration",
              -- opts.jdtls_config_dir(project_name),
              "-data",
              opts.jdtls_workspace_dir(project_name),
            })
          end
          return cmd1
        end,

        test = true,
        settings = {
          java = {
            autobuild = {
              enabled = false,
            },
            eclipse = { downloadSources = true },
            edit = {
              validateAllOpenBuffersOnChanges = false,
            },
            format = {
              enabled = true,
            },
            progressReports = {
              enabled = false,
            },
            configuration = {
              updateBuildConfiguration = "disabled",
              maven = {
                userSettings = "none",
              },
              runtimes = {
                {
                  name = "JavaSE-11",
                  path = "~/.jenv/jvm/jdk-11.0.9.1+1/",
                  default = true,
                },
                {
                  name = "JavaSE-17",
                  path = "/usr/lib/jvm/java-17-openjdk/",
                },
                {
                  name = "JavaSE-21",
                  path = "/usr/lib/jvm/java-21-openjdk/",
                },
              },
            },
            diagnostic = {
              refreshAfterSave = true,
            },
            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = false },
            referencesCodeLens = { enabled = false },
            inlayHints = { parameterNames = { enabled = false } },
            signatureHelp = { enabled = true },
            contentProvider = {
              preferred = "fernflower",
            },
            completion = {
              enabled = true,
              favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.junit.Assert.*",
                "org.mockito.Mockito.*",
              },
              filteredTypes = {
                "com.sun.*",
                "io.micrometer.shaded.*",
                "java.awt.*",
                "jdk.*",
                "sun.*",
              },
              guessMethodArguments = "off",
              maxResults = 30,
              postfix = true,
              matchCase = "OFF",
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
            init_options = {},
            handlers = {
              ["$/progress"] = function() end, -- disable progress updates.
            },
            -- handlers = {
            --   ["$/progress"] = function() end, -- disable progress updates.
            -- },
            flags = {
              debounce_text_changes = 300, -- 增加输入防抖
              allow_incremental_sync = true,
            },
            filetypes = { "java" },
          },
        },
        on_attach = function()
          require("jdtls").setup_dap({
            hotcodereplace = "auto",
            config_overrides = {},
          })
          require("jdtls.dap").setup_dap_main_class_configs({})
        end,
      }
    end,
    config = function(_, opts)
      -- Find the extra bundles that should be passed on the jdtls command-line
      -- if nvim-dap is enabled with java debug/test.
      local init_options = {
        bundles = {
          vim.fn.expand("$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
          -- unpack remaining bundles
          (table.unpack or unpack)(
                vim.split(vim.fn.glob("$HOME/.vscode/extensions/vscjava.vscode-java-test-0.43.1/server/*.jar"), "\n", {})
              ),
        },
        extendedClientCapabilities = {
          classFileContentsSupport = true,
          resolveAdditionalTextEditsSupport = true,
          progressReportProvider = true,
          generateToStringPromptSupport = true,
          advancedExtractRefactoringSupport = true,
          advancedOrganizeImportsSupport = true,
          -- 关键优化：关闭高开销功能
          completion = {
            maxResults = 30,    -- 限制补全结果数量
            lazyResolve = true, -- 延迟解析补全项
          },
          shouldLanguageServerExitOnShutdown = true,
        },
      } ---@type string[]
      local function attach_jdtls()
        local fname = vim.api.nvim_buf_get_name(0)

        -- Configuration can be augmented and overridden by opts.jdtls
        local config = extend_or_override({
          cmd = opts.full_cmd(opts),
          root_dir = opts.root_dir(fname),
          init_options = init_options,
          settings = opts.settings,
        }, opts.jdtls)

        -- Existing server will be reused if the root_dir matches.
        require("jdtls").start_or_attach(config)
        -- not need to require("jdtls.setup").add_commands(), start automatically adds commands
      end

      -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
      -- depending on filetype, so this autocmd doesn't run for the first file.
      -- For that, we call directly below.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = java_filetypes,
        callback = attach_jdtls,
      })

      local wk = require("which-key")
      wk.add({
        {
          mode = "n",
          { "<leader>cx",  group = "extract" },
          { "<leader>cxv", require("jdtls").extract_variable_all, desc = "Extract Variable" },
          { "<leader>cxc", require("jdtls").extract_constant,     desc = "Extract Constant" },
          { "<leader>cgs", require("jdtls").super_implementation, desc = "Goto Super" },
          { "<leader>cgS", require("jdtls.tests").goto_subjects,  desc = "Goto Subjects" },
          { "<leader>co",  require("jdtls").organize_imports,     desc = "Organize Imports" },
        },
      })
      wk.add({
        {
          mode = "v",
          { "<leader>cx", group = "extract" },
          {
            "<leader>cxm",
            [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
            desc = "Extract Method",
          },
          {
            "<leader>cxv",
            [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
            desc = "Extract Variable",
          },
          {
            "<leader>cxc",
            [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
            desc = "Extract Constant",
          },
        },
      })
      wk.add({
        {
          mode = "n",
          { "<leader>t",  group = "test" },
          {
            "<leader>tt",
            function()
              require("jdtls.dap").test_class({
                config_overrides = type(opts.test) ~= "boolean" and opts.test.config_overrides or nil,
              })
            end,
            desc = "Run All Test",
          },
          {
            "<leader>tr",
            function()
              require("jdtls.dap").test_nearest_method({
                config_overrides = type(opts.test) ~= "boolean" and opts.test.config_overrides or nil,
              })
            end,
            desc = "Run Nearest Test",
          },
          { "<leader>tT", require("jdtls.dap").pick_test, desc = "Run Test" },
        },
      })
      -- Avoid race condition by calling attach the first time, since the autocmd won't fire.
      attach_jdtls()
    end,
  },
  {
    "JavaHello/spring-boot.nvim",
    ft = { "java", "yaml", "jproperties" },
    specs = {
      {
        "mfussenegger/nvim-jdtls",
        optional = true,
        opts = function(_, opts)
          if not opts.init_options then
            opts.init_options = {}
          end
          if not opts.init_options.bundles then
            opts.init_options.bundles = {}
          end
          vim.list_extend(opts.init_options.bundles, require("spring_boot").java_extensions())
        end,
      },
    },
    opts = {
      java_cmd = "/usr/lib/jvm/java-21-openjdk/bin/java",
      exploded_ls_jar_data = true,
    },
  },
  {
    "rcasia/neotest-java",
    ft = "java",
    dependencies = {
      "mfussenegger/nvim-dap", -- for the debugger
      "rcarriga/nvim-dap-ui",  -- recommended
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      if not opts.adapters then
        opts.adapters = {}
      end
      table.insert(opts.adapters, require("neotest-java")({}))
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        java = { "google-java-format", lsp_format = "last" },
      },
    },
  },
}
