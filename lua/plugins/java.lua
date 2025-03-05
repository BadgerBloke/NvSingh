return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  config = function()
    local home = os.getenv("HOME")
    local lombok_agent = home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar"

    -- Ensure Lombok agent is added to JVM arguments
    vim.env.JDTLS_JVM_ARGS = "-javaagent:" .. lombok_agent

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        local jdtls = require("jdtls")
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        local workspace_dir = home .. "/.local/share/nvim/jdtls-workspace/" .. project_name

        local config = {
          cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-javaagent:" .. lombok_agent,
            "-jar",
            vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
            "-configuration",
            home .. "/.local/share/nvim/mason/packages/jdtls/config_mac",
            "-data",
            workspace_dir,
          },
          root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
          settings = {
            java = {
              configuration = {
                runtimes = {
                  {
                    name = "JavaSE-21",
                    path = "/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home",
                  },
                },
              },
              import = {
                gradle = { enabled = true },
                maven = { enabled = true },
              },
              maven = {
                downloadSources = true,
              },
            },
          },
          init_options = {
            bundles = {
              lombok_agent,
            },
            extendedClientCapabilities = {
              classFileContentsSupport = true,
            },
          },
        }

        jdtls.start_or_attach(config)

        -- Debug keymap
        vim.keymap.set("n", "<leader>ll", function()
          vim.notify("Lombok Agent: " .. lombok_agent, vim.log.levels.INFO)
        end, { buffer = true, desc = "Show Lombok Agent Path" })
      end,
    })
  end,
}
