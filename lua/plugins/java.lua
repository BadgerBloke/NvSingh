return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  config = function()
    local home = os.getenv("HOME") or os.getenv("USERPROFILE")
    local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

    -- Set paths based on OS
    local lombok_agent
    local java_cmd
    local jdtls_config_dir
    local java_runtime_path

    if is_windows then
      -- Windows paths
      lombok_agent = home .. "\\AppData\\Local\\nvim-data\\mason\\packages\\jdtls\\lombok.jar"
      java_cmd = "C:\\Program Files\\Java\\jdk-21\\bin\\java.exe"
      jdtls_config_dir = home .. "\\AppData\\Local\\nvim-data\\mason\\packages\\jdtls\\config_win"
      java_runtime_path = "C:\\Program Files\\Java\\jdk-21"
    else
      -- macOS/Linux paths
      lombok_agent = home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar"
      java_cmd = "java"
      jdtls_config_dir = home .. "/.local/share/nvim/mason/packages/jdtls/config_mac"
      java_runtime_path = "/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home"
    end

    -- Ensure Lombok agent is added to JVM arguments
    vim.env.JDTLS_JVM_ARGS = "-javaagent:" .. lombok_agent

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        local jdtls = require("jdtls")
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

        -- Create workspace directory path based on OS
        local workspace_dir
        if is_windows then
          workspace_dir = home .. "\\AppData\\Local\\nvim-data\\jdtls-workspace\\" .. project_name
        else
          workspace_dir = home .. "/.local/share/nvim/jdtls-workspace/" .. project_name
        end

        -- Find the launcher jar using globbing patterns appropriate for the OS
        local launcher_jar
        if is_windows then
          launcher_jar = vim.fn.glob(
            home .. "\\AppData\\Local\\nvim-data\\mason\\packages\\jdtls\\plugins\\org.eclipse.equinox.launcher_*.jar"
          )
        else
          launcher_jar =
            vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
        end

        local config = {
          cmd = {
            java_cmd,
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
            launcher_jar,
            "-configuration",
            jdtls_config_dir,
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
                    path = java_runtime_path,
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
          vim.notify("OS: " .. (is_windows and "Windows" or "macOS/Linux"), vim.log.levels.INFO)
        end, { buffer = true, desc = "Show Lombok Agent Path and OS" })
      end,
    })
  end,
}
