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
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "jdtls" })
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
      "williamboman/mason-lspconfig.nvim",
      {
        "AstroNvim/astrolsp",
        optional = true,
        ---@type AstroLSPOpts
        opts = function(_, opts)
          local maps = opts.mappings
          maps.n["<Leader>lj"] = { function() require("jdtls").set_runtime() end, desc = "set jdk version" }
          local utils = require "astrocore"
          return utils.extend_tbl({
            ---@diagnostic disable: missing-fields
            handlers = { jdtls = false },
          }, opts)
        end,
      },
    },
    opts = function()
      return {
        cmd = {
          "/usr/lib/jvm/java-21-openjdk/bin/java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=false",
          "-Dlog.level=Error",
          "-javaagent:" .. vim.fn.expand "$MASON/share/jdtls/lombok.jar",
          "-Xms2g",       -- 初始堆内存提升
          "-Xmx4g",       -- 最大堆内存提升
          "-XX:+UseG1GC", -- 启用 G1 GC
          "-XX:MaxGCPauseMillis=200",
          "--add-modules=ALL-MODULE-PATH",
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",
          "-jar",
          vim.fn.expand "$MASON/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
        },
        root_dir = require("lspconfig.configs.jdtls").default_config.root_dir,
        project_name = function(root_dir)
          return root_dir and vim.fs.basename(root_dir)
        end,
        -- Where are the config and workspace dirs for a project?
        jdtls_config_dir = function()
          return vim.fn.expand "$MASON/share/jdtls/config"
        end,
        jdtls_workspace_dir = function(project_name)
          return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
        end,
        full_cmd = function(opts)
          local fname = vim.api.nvim_buf_get_name(0)
          local root_dir = opts.root_dir(fname)
          local project_name = opts.project_name(root_dir)
          local cmd = vim.deepcopy(opts.cmd)
          if project_name then
            vim.list_extend(cmd, {
              "-configuration",
              opts.jdtls_config_dir(),
              "-data",
              opts.jdtls_workspace_dir(project_name),
            })
          end
          return cmd
        end,
        settings = {
          java = {
            eclipse = { downloadSources = true },
            configuration = {
              updateBuildConfiguration = "interactive",
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
            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = false },
            inlayHints = { parameterNames = { enabled = false } },
            signatureHelp = { enabled = true },
            completion = {
              favoriteStaticMembers = {
                "org.hamcrest.MatcherAssert.assertThat",
                "org.hamcrest.Matchers.*",
                "org.hamcrest.CoreMatchers.*",
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
                "org.mockito.Mockito.*",
              },
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
          },
        },
        handlers = {
          ["$/progress"] = function() end, -- disable progress updates.
        },
        dap = { hotcodereplace = "auto", config_overrides = {} },
        -- Can set this to false to disable main class scan, which is a performance killer for large project
        dap_main = false,
        test = true,
      }
    end,
    config = function(_, opts)
      local utils = require "astrocore"
      local function attach_jdtls()
        local fname = vim.api.nvim_buf_get_name(0)

        -- Configuration can be augmented and overridden by opts.jdtls
        local config = utils.extend_tbl({
          cmd = opts.full_cmd(opts),
          root_dir = opts.root_dir(fname),
          init_options = {
            bundles = {
              vim.fn.expand "$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar",
              -- unpack remaining bundles
              (table.unpack or unpack)(vim.split(vim.fn.glob "$MASON/share/java-test/*.jar", "\n", {})),
            }
          },
          settings = opts.settings,
          handlers = opts.handlers,
          -- enable CMP capabilities
        }, opts.jdtls)

        -- Existing server will be reused if the root_dir matches.
        require("jdtls").start_or_attach(config)
        -- not need to require("jdtls.setup").add_commands(), start automatically adds commands
      end

      -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
      -- depending on filetype, so this autocmd doesn't run for the first file.
      -- For that, we call directly below.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "java" },
        callback = attach_jdtls,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "jdtls" then
            require("jdtls").setup_dap(opts.dap)
            if opts.dap_main then
              require("jdtls.dap").setup_dap_main_class_configs(opts.dap_main)
            end

            -- User can set additional keymaps in opts.on_attach
            if opts.on_attach then
              opts.on_attach(args)
            end
          end
        end
      })

      -- Avoid race condition by calling attach the first time, since the autocmd won't fire.
      attach_jdtls()
    end,

  },
}
