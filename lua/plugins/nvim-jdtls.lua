return {
  { import = "astrocommunity.pack.xml" },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "java" })
      end
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "javadbg", "javatest" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed =
          require("astrocore").list_insert_unique(opts.ensure_installed, { "jdtls", "java-debug-adapter", "java-test" })
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
      {
        "AstroNvim/astrolsp",
        optional = true,
        ---@type AstroLSPOpts
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>lv"] = { function() require("jdtls").set_runtime() end, desc = "set jdk version" }
          maps.n["<Leader>lC"] = {
            function() require("toggleterm").exec("mvnd compile", 0, 50, "", "vertical", "", true, false) end,
            desc =
            "compile"
          }
          local utils = require "astrocore"
          return utils.extend_tbl({
            ---@diagnostic disable: missing-fields
            handlers = { jdtls = false },
          }, opts)
        end,
      },
    },
    opts = function(_, opts)
      local utils = require "astrocore"
      -- use this function notation to build some variables
      local root_markers = { ".git", "pom.xml", "mvnw", "gradlew", "build.gradle", ".project" }
      -- local root_markers = { "pom.xml", "gradlew" }
      -- local root_dir = require("jdtls.setup").find_root(root_markers)
      local root_dir =
          vim.fs.dirname(vim.fs.find({ ".git", "pom.xml", ".project", "gradlew", "mvnw" }, { upward = true })[1])
      -- calculate workspace dir
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
      -- vim.fn.mkdir(workspace_dir, "p")

      -- validate operating system
      if not (vim.fn.has "mac" == 1 or vim.fn.has "unix" == 1 or vim.fn.has "win32" == 1) then
        utils.notify("jdtls: Could not detect valid OS", vim.log.levels.ERROR)
      end

      return utils.extend_tbl({
        cmd = {
          "/usr/lib/jvm/java-21-openjdk/bin/java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=6",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog:disable",
          "-Djdt.ls.debug=false",
          "-Dlombok.disableConfig=true",
          "-Dsun.zip.disableMemoryMapping=true",
          "-javaagent:" .. vim.fn.expand "$MASON/share/jdtls/lombok.jar",
          "-Xms2g",             -- 初始堆内存提升
          "-Xmx8g",             -- 最大堆内存提升
          "-XX:+UseParallelGC", -- 启用 G1 GC
          "-XX:GCTimeRatio=4",  -- 启用 G1 GC
          "-XX:AdaptiveSizePolicyWeight=90",
          "-XX:+UseStringDeduplication",
          "-XX:MetaspaceSize=512M",
          "--add-modules=ALL-SYSTEM",
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",
          "-jar",
          vim.fn.expand "$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
          "-configuration",
          vim.fn.expand "$MASON/share/jdtls/config",
          "-data",
          workspace_dir,
        },
        root_dir = root_dir,
        settings = {
          java = {
            autobuild = {
              enabled = true,
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
              updateBuildConfiguration = "automatic",
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
              refreshAfterSave = false,
            },
            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = false },
            referencesCodeLens = { enabled = false },
            inlayHints = { parameterNames = { enabled = false } },
            signatureHelp = { enabled = false },
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
                "org.mockito.Mockito.*",
              },
              filteredTypes = {
                "com.sun.*",
                "io.micrometer.shaded.*",
                "java.awt.*",
                "jdk.*",
                "sun.*",
              },
              guessMethodArguments = true,
              maxResults = 30,
              postfix = false,
              matchCase = "OFF",
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
          },
        },
        init_options = {
          bundles = {
            vim.fn.expand "$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
            -- unpack remaining bundles
            (table.unpack or unpack)(vim.split(
                  vim.fn.glob "$HOME/.vscode/extensions/vscjava.vscode-java-test-0.43.1/server/*.jar", "\n", {})),
          },
          extendedClientCapabilities = {
            classFileContentsSupport = true,
          },
        },
        handlers = {
          ["$/progress"] = function() end, -- disable progress updates.
        },
        filetypes = { "java" },
        on_attach = function(...)
          require("jdtls").setup_dap { hotcodereplace = "auto" }
          local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
          if astrolsp_avail then astrolsp.on_attach(...) end
        end,
      }, opts)
    end,
    config = function(_, opts)
      -- setup autocmd on filetype detect java
      vim.api.nvim_create_autocmd("Filetype", {
        pattern = "java", -- autocmd to start jdtls
        callback = function()
          if opts.root_dir and opts.root_dir ~= "" then
            require("jdtls").start_or_attach(opts)
          else
            require("astrocore").notify("jdtls: root_dir not found. Please specify a root marker", vim.log.levels.ERROR)
          end
        end,
      })
      -- create autocmd to load main class configs on LspAttach.
      -- This ensures that the LSP is fully attached.
      -- See https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
      vim.api.nvim_create_autocmd("LspAttach", {
        pattern = "*.java",
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          -- ensure that only the jdtls client is activated
          if client.name == "jdtls" then require("jdtls.dap").setup_dap_main_class_configs() end
        end,
      })
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
          if not opts.init_options then opts.init_options = {} end
          if not opts.init_options.bundles then opts.init_options.bundles = {} end
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
      "mfussenegger/nvim-jdtls",
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "rcasia/neotest-java" },
    opts = function(_, opts)
      if not opts.adapters then opts.adapters = {} end
      table.insert(opts.adapters, require "neotest-java" (require("astrocore").plugin_opts "neotest-java"))
    end,
  },
}
