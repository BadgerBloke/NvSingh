return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  config = function()
    local home = os.getenv("HOME")

    -- Function to get Java command and JAVA_HOME
    local function get_java_info()
      local java_cmd = "java"
      local java_home = nil

      -- Try to get JAVA_HOME from environment
      java_home = os.getenv("JAVA_HOME")

      -- If JAVA_HOME is not set, try to detect it
      if not java_home then
        -- Try SDKMAN current Java
        local sdkman_java = home .. "/.sdkman/candidates/java/current"
        if vim.fn.isdirectory(sdkman_java) == 1 then
          java_home = sdkman_java
          java_cmd = sdkman_java .. "/bin/java"
        else
          -- Try to find java executable and derive JAVA_HOME
          local java_path = vim.fn.exepath("java")
          if java_path and java_path ~= "" then
            -- java_path is typically /path/to/java_home/bin/java
            java_home = vim.fn.fnamemodify(java_path, ":h:h")
            java_cmd = java_path
          end
        end
      else
        java_cmd = java_home .. "/bin/java"
      end

      return java_cmd, java_home
    end

    -- Function to get Java version for runtime configuration
    local function get_java_version(java_cmd)
      local handle = io.popen(java_cmd .. " -version 2>&1")
      if handle then
        local result = handle:read("*a")
        handle:close()

        -- Extract version number (works for both old and new versioning schemes)
        local major_version = result:match('version "(%d+)')
        if major_version then
          return tonumber(major_version)
        end

        -- Fallback for different version formats
        local version_match = result:match('version "1%.(%d+)') -- For Java 8 and below
        if version_match then
          return tonumber(version_match)
        end
      end
      return 21 -- Default fallback
    end

    local java_cmd, java_home = get_java_info()
    local java_version = get_java_version(java_cmd)

    -- Set macOS paths
    local mason_path = home .. "/.local/share/nvim/mason"
    local lombok_agent = mason_path .. "/packages/jdtls/lombok.jar"
    local jdtls_config_dir = mason_path .. "/packages/jdtls/config_mac"

    -- Ensure Lombok agent is added to JVM arguments
    vim.env.JDTLS_JVM_ARGS = "-javaagent:" .. lombok_agent

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        local jdtls = require("jdtls")
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

        -- Create workspace directory path
        local workspace_dir = home .. "/.local/share/nvim/jdtls-workspace/" .. project_name

        -- Find the launcher jar
        local launcher_jar = vim.fn.glob(mason_path .. "/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")

        -- Build JVM arguments based on Java version
        local jvm_args = {
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xmx1g",
          "-javaagent:" .. lombok_agent,
        }

        -- Add module system arguments for Java 9+
        if java_version >= 9 then
          vim.list_extend(jvm_args, {
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
          })
        end

        local config = {
          cmd = vim.list_extend(
            {
              java_cmd,
            },
            vim.list_extend(jvm_args, {
              "-jar",
              launcher_jar,
              "-configuration",
              jdtls_config_dir,
              "-data",
              workspace_dir,
            })
          ),
          root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
          settings = {
            java = {
              configuration = {
                runtimes = java_home and {
                  {
                    name = "JavaSE-" .. java_version,
                    path = java_home,
                  },
                } or {},
              },
              import = {
                gradle = { enabled = true },
                maven = { enabled = true },
              },
              maven = {
                downloadSources = true,
              },
              signatureHelp = { enabled = true },
              contentProvider = { preferred = "fernflower" },
              completion = {
                favoriteStaticMembers = {
                  "org.hamcrest.MatcherAssert.assertThat",
                  "org.hamcrest.Matchers.*",
                  "org.hamcrest.CoreMatchers.*",
                  "org.junit.jupiter.api.Assertions.*",
                  "java.util.Objects.requireNonNull",
                  "java.util.Objects.requireNonNullElse",
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
          init_options = {
            bundles = {},
            extendedClientCapabilities = {
              classFileContentsSupport = true,
            },
          },
        }

        jdtls.start_or_attach(config)

        -- Debug keymap
        vim.keymap.set("n", "<leader>ll", function()
          vim.notify("Java Command: " .. java_cmd, vim.log.levels.INFO)
          vim.notify("Java Home: " .. (java_home or "Not detected"), vim.log.levels.INFO)
          vim.notify("Java Version: " .. java_version, vim.log.levels.INFO)
          vim.notify("Lombok Agent: " .. lombok_agent, vim.log.levels.INFO)
        end, { buffer = true, desc = "Show Java LSP Configuration" })

        -- Additional useful keymaps
        local bufopts = { noremap = true, silent = true, buffer = true }
        vim.keymap.set("n", "<leader>co", jdtls.organize_imports, bufopts)
        vim.keymap.set("n", "<leader>crv", jdtls.extract_variable, bufopts)
        vim.keymap.set("n", "<leader>crc", jdtls.extract_constant, bufopts)
        vim.keymap.set("v", "<leader>crm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], bufopts)
      end,
    })
  end,
}
