return {
  "mfussenegger/nvim-jdtls",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "mfussenegger/nvim-dap",
    "nvim-lua/plenary.nvim",
  },
  ft = { "java" },
  config = function()
    local home = os.getenv("USERPROFILE") or os.getenv("HOME")
    local mason_registry = require("mason-registry")

    -- Ensure required Mason packages are installed
    local ensure_installed = function(package_name)
      if mason_registry.has_package(package_name) then
        if not mason_registry.is_installed(package_name) then
          vim.cmd("MasonInstall " .. package_name)
        end
      else
        print("Package " .. package_name .. " not found in Mason registry")
      end
    end

    ensure_installed("jdtls")
    ensure_installed("java-debug-adapter")
    ensure_installed("java-test")

    -- Try to install vscode-spring-boot extension (it might not be available in Mason)
    if mason_registry.has_package("vscode-spring-boot") then
      ensure_installed("vscode-spring-boot")
    elseif mason_registry.has_package("spring-boot-java-language-server") then
      ensure_installed("spring-boot-java-language-server")
    end

    -- Defer setup to FileType event for better LazyVim compatibility
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = function()
        local jdtls = require("jdtls")
        local jdtls_setup = require("jdtls.setup")

        -- Custom function to find project root
        local root_markers = {
          "pom.xml",
          "build.gradle",
          "build.gradle.kts",
          "settings.gradle",
          "settings.gradle.kts",
          ".git",
          "mvnw",
          "gradlew",
        }

        local root_dir = jdtls_setup.find_root(root_markers)
        if root_dir == "" then
          root_dir = vim.fn.getcwd()
        end

        -- Get proper workspace folder name for LSP data
        local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
        local workspace_dir = home .. "/.cache/jdtls-workspace/" .. project_name

        -- Ensure workspace directory exists
        vim.fn.mkdir(workspace_dir, "p")

        -- Set up DAP
        jdtls_setup.add_commands()

        -- Make sure java-test and java-debug-adapter are installed
        local bundles = {}

        -- Get java-test path if installed
        if mason_registry.is_installed("java-test") then
          local java_test_path = mason_registry.get_package("java-test"):get_install_path()
          local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n")
          if java_test_bundle[1] ~= "" then
            vim.list_extend(bundles, java_test_bundle)
          end
        end

        -- Get java-debug-adapter path if installed
        if mason_registry.is_installed("java-debug-adapter") then
          local java_debug_path = mason_registry.get_package("java-debug-adapter"):get_install_path()
          local java_debug_bundle =
            vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
          if java_debug_bundle[1] ~= "" then
            vim.list_extend(bundles, java_debug_bundle)
          end
        end

        -- Try to get spring boot bundles if they exist
        local spring_boot_bundles = {}
        for _, name in ipairs({ "vscode-spring-boot", "spring-boot-java-language-server" }) do
          if mason_registry.is_installed(name) then
            local path = mason_registry.get_package(name):get_install_path()
            local spring_jar = vim.fn.glob(path .. "/extension/server/spring-boot-language-server-*.jar")
            if spring_jar ~= "" then
              table.insert(spring_boot_bundles, spring_jar)
              break
            end
          end
        end

        -- Command that starts the language server
        local cmd = {
          -- IMPORTANT: Use your system-installed Java here, not from Mason
          "C:\\Program Files\\Java\\jdk-21\\bin\\java.exe",

          -- Adjust JVM settings as needed
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xmx1G",
          "--add-modules=ALL-SYSTEM",
          "--add-opens",
          "java.base/java.util=ALL-UNNAMED",
          "--add-opens",
          "java.base/java.lang=ALL-UNNAMED",

          -- Get JDTLS from Mason
          "-jar",
          vim.fn.glob(
            home .. "/AppData/Local/nvim-data/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
          ),

          -- Configuration path
          "-configuration",
          home .. "/AppData/Local/nvim-data/mason/packages/jdtls/config_win",

          -- Apply bundles
          "-data",
          workspace_dir,
        }

        -- Main config
        local config = {
          cmd = cmd,
          root_dir = root_dir,
          settings = {
            java = {
              home = "C:\\Program Files\\Java\\jdk-21",
              eclipse = {
                downloadSources = true,
              },
              configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = {
                  {
                    name = "JavaSE-21",
                    path = "C:\\Program Files\\Java\\jdk-21",
                    default = true,
                  },
                },
              },
              maven = {
                downloadSources = true,
              },
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
              },
              references = {
                includeDecompiledSources = true,
              },
              format = {
                enabled = true,
              },
              completion = {
                favoriteStaticMembers = {
                  "org.hamcrest.MatcherAssert.assertThat",
                  "org.hamcrest.Matchers.*",
                  "org.hamcrest.CoreMatchers.*",
                  "org.junit.jupiter.api.Assertions.*",
                  "java.util.Objects.requireNonNull",
                  "java.util.Objects.requireNonNullElse",
                  "org.mockito.Mockito.*",
                  -- Spring-related imports
                  "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
                  "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
                },
              },
              sources = {
                organizeImports = {
                  starThreshold = 9999,
                  staticStarThreshold = 9999,
                },
              },
              codeGeneration = {
                toString = {
                  template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                useBlocks = true,
              },
            },
            signatureHelp = {
              enabled = true,
            },
            contentProvider = {
              preferred = "fernflower",
            },
          },
          flags = {
            allow_incremental_sync = true,
          },
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          init_options = {
            bundles = vim.list_extend(bundles, spring_boot_bundles),
            -- Enable extended client capabilities
            extendedClientCapabilities = {
              progressReportProvider = true,
              classFileContentsSupport = true,
              overrideMethodsPromptSupport = true,
              hashCodeEqualsPromptSupport = true,
              advancedOrganizeImportsSupport = true,
              advancedGenerateAccessorsSupport = true,
              advancedExtractRefactoringSupport = true,
              generateToStringPromptSupport = true,
              advancedGenerateToStringSupport = true,
              generateConstructorsPromptSupport = true,
              generateDelegateMethodsPromptSupport = true,
              moveRefactoringSupport = true,
              clientHoverProvider = true,
              resolveAdditionalTextEditsSupport = true,
            },
          },
        }

        -- Set up JDTLS for current buffer
        jdtls.start_or_attach(config)

        -- Safe keymapping function that checks if functions exist before binding
        local function safe_keymap(mode, lhs, rhs, opts)
          if type(rhs) == "function" or type(rhs) == "string" then
            vim.keymap.set(mode, lhs, rhs, opts)
          end
        end

        -- Set up key mappings for Java development if functions exist
        safe_keymap("n", "<leader>ji", jdtls.organize_imports, { buffer = 0, desc = "Organize Imports" })
        safe_keymap("n", "<leader>jt", jdtls.test_class, { buffer = 0, desc = "Test Class" })
        safe_keymap("n", "<leader>jn", jdtls.test_nearest_method, { buffer = 0, desc = "Test Nearest Method" })
        safe_keymap("n", "<leader>jc", function()
          jdtls.compile("full")
        end, { buffer = 0, desc = "Compile Project" })

        -- Spring Boot specific keymaps - these use Telescope to search for Spring-related symbols
        if pcall(require, "telescope") then
          safe_keymap("n", "<leader>jb", function()
            vim.cmd("Telescope lsp_workspace_symbols query=@")
          end, { buffer = 0, desc = "List Spring Beans" })
          safe_keymap("n", "<leader>je", function()
            vim.cmd("Telescope lsp_workspace_symbols query=@/")
          end, { buffer = 0, desc = "List REST Endpoints" })
        end

        -- Check if jdtls.dap module exists before setting up DAP keymaps
        if jdtls.dap and jdtls.dap.setup_dap_main_class_configs then
          safe_keymap("n", "<leader>jv", function()
            jdtls.dap.setup_dap_main_class_configs()
          end, { buffer = 0, desc = "Setup DAP Main Class" })
        end

        -- Check if jdtls.outline function exists
        if jdtls.outline then
          safe_keymap("n", "<leader>jo", jdtls.outline, { buffer = 0, desc = "Show Outline" })
        end
      end,
      group = vim.api.nvim_create_augroup("jdtls_config", { clear = true }),
    })
  end,
}
