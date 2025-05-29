return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
  },
  {
    "mxsdev/nvim-dap-vscode-js",
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      local Config = require("lazyvim.config")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(Config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- Set dap defaults after dapui setup
      dap.defaults.fallback.exception_breakpoints = { "uncaught" }

      -- JavaScript/TypeScript/Node.js adapter configuration
      for _, adapterType in ipairs({ "node", "chrome", "msedge" }) do
        local pwaType = "pwa-" .. adapterType

        dap.adapters[pwaType] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }

        -- Handle launch.json configurations
        dap.adapters[adapterType] = function(cb, config)
          local nativeAdapter = dap.adapters[pwaType]
          config.type = pwaType

          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      local enter_launch_url = function()
        local co = coroutine.running()
        return coroutine.create(function()
          vim.ui.input({ prompt = "Enter URL: ", default = "http://localhost:" }, function(url)
            if url == nil or url == "" then
              return
            else
              coroutine.resume(co, url)
            end
          end)
        end)
      end

      -- Language configurations
      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file using Node.js (nvim-dap)",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process using Node.js (nvim-dap)",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file using Node.js with ts-node/register (nvim-dap)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeArgs = { "-r", "ts-node/register" },
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome (nvim-dap)",
            url = enter_launch_url,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-msedge",
            request = "launch",
            name = "Launch Edge (nvim-dap)",
            url = enter_launch_url,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
          },
        }
      end

      -- .NET Core adapter configuration
      dap.adapters.coreclr = {
        type = "executable",
        command = "C:/Users/sfree/AppData/Local/nvim-data/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe",
        args = { "--interpreter=vscode" },
      }

      local dotnet_build_project = function()
        local default_path = vim.fn.getcwd() .. "/"

        if vim.g["dotnet_last_proj_path"] ~= nil then
          default_path = vim.g["dotnet_last_proj_path"]
        end

        local path = vim.fn.input("Path to your *proj file", default_path, "file")
        vim.g["dotnet_last_proj_path"] = path

        local cmd = "dotnet build -c Debug " .. path .. " > /dev/null"
        print("")
        print("Cmd to execute: " .. cmd)

        local f = os.execute(cmd)

        if f == 0 then
          print("\nBuild: ✔️ ")
        else
          print("\nBuild: ❌ (code: " .. f .. ")")
        end
      end

      local dotnet_get_dll_path = function()
        local request = function()
          return vim.fn.input("Path to dll to debug: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end

        if vim.g["dotnet_last_dll_path"] == nil then
          vim.g["dotnet_last_dll_path"] = request()
        else
          if vim.fn.confirm("Change the path to dll?\n" .. vim.g["dotnet_last_dll_path"], "&yes\n&no", 2) == 1 then
            vim.g["dotnet_last_dll_path"] = request()
          end
        end

        return vim.g["dotnet_last_dll_path"]
      end

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch - coreclr (nvim-dap)",
          request = "launch",
          program = function()
            if vim.fn.confirm("Rebuild first?", "&yes\n&no", 2) == 1 then
              dotnet_build_project()
            end
            return dotnet_get_dll_path()
          end,
        },
      }

      local convertArgStringToArray = function(config)
        local c = {}
        for k, v in pairs(vim.deepcopy(config)) do
          if k == "args" and type(v) == "string" then
            c[k] = require("dap.utils").splitstr(v)
          else
            c[k] = v
          end
        end
        return c
      end

      for key, _ in pairs(dap.configurations) do
        dap.listeners.on_config[key] = convertArgStringToArray
      end

      vim.schedule(function()
        dapui.setup({
          controls = {
            element = "repl",
            enabled = true,
            icons = {
              disconnect = "",
              pause = "",
              play = "",
              run_last = "",
              step_back = "",
              step_into = "",
              step_out = "",
              step_over = "",
              terminate = "",
            },
          },
          element_mappings = {},
          expand_lines = true,
          floating = {
            border = "rounded",
            mappings = {
              close = { "q", "<Esc>" },
            },
          },
          force_buffers = true,
          icons = {
            collapsed = "",
            current_frame = "",
            expanded = "",
          },
          layouts = {
            {
              elements = {
                {
                  id = "scopes",
                  size = 0.25,
                },
                {
                  id = "breakpoints",
                  size = 0.25,
                },
                {
                  id = "stacks",
                  size = 0.25,
                },
                {
                  id = "watches",
                  size = 0.25,
                },
              },
              position = "right",
              size = 50,
            },
            {
              elements = {
                {
                  id = "repl",
                  size = 0.5,
                },
                {
                  id = "console",
                  size = 0.5,
                },
              },
              position = "bottom",
              size = 10,
            },
          },
          mappings = {
            edit = "e",
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            repl = "r",
            toggle = "t",
          },
          render = {
            indent = 1,
            max_value_lines = 100,
          },
        })
      end)
      -- DAP UI event listeners
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
    keys = {
      {
        "<Leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle breakpoint",
      },
      {
        "<Leader>dx",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "Clear all breakpoints",
      },
      {
        "<Leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<Leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<Leader>dc",
        function()
          -- Support for vscode launch.json
          if vim.fn.filereadable(".vscode/launch.json") then
            local ok, err = pcall(require("dap.ext.vscode").load_launchjs)
            if not ok then
              vim.notify("Error loading launch.json: " .. err, vim.log.levels.WARN)
            end
          end
          require("dap").continue()
        end,
        desc = "Continue",
      },
    },
  },
}
