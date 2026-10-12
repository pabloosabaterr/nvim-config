-- C, C++, Rust y ARM64 con lldb-dap (viene con Xcode / Command Line Tools)
-- Go con delve (go install github.com/go-delve/delve/cmd/dlv@latest)

local function lldb_dap_path()
  local p = vim.fn.exepath("lldb-dap")
  if p ~= "" then return p end
  local out = vim.fn.system({ "xcrun", "--find", "lldb-dap" })
  if vim.v.shell_error == 0 then return vim.trim(out) end
  return "lldb-dap"
end

local function dlv_path()
  local p = vim.fn.exepath("dlv")
  if p ~= "" then return p end
  return vim.fn.expand("~/go/bin/dlv")
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "igorlfs/nvim-dap-view" },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: continuar" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: step out" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continuar / iniciar" },
      { "<leader>dn", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Breakpoint" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input("Condición: ")) end,
        desc = "Breakpoint condicional",
      },
      { "<leader>dr", function() require("dap").run_last() end, desc = "Repetir última sesión" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Ejecutar hasta el cursor" },
      { "<leader>dq", function() require("dap").terminate() end, desc = "Terminar" },
      { "<leader>dv", "<cmd>DapViewToggle<CR>", desc = "Paneles de debug" },
      { "<leader>dw", "<cmd>DapViewWatch<CR>", desc = "Vigilar expresión" },
    },
    config = function()
      local dap = require("dap")

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

      dap.adapters.lldb = {
        type = "executable",
        command = lldb_dap_path(),
        name = "lldb",
      }

      local lldb = {
        {
          name = "Lanzar ejecutable",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Ejecutable: ", vim.fn.getcwd() .. "/", "file")
          end,
          args = function()
            local a = vim.fn.input("Argumentos: ")
            return a == "" and {} or vim.split(a, " +", { trimempty = true })
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name = "Adjuntar a proceso",
          type = "lldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
        },
      }
      dap.configurations.c = lldb
      dap.configurations.cpp = lldb
      dap.configurations.rust = lldb
      dap.configurations.arm64asm = lldb

      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = dlv_path(),
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }
      dap.configurations.go = {
        { type = "delve", name = "Fichero actual", request = "launch", program = "${file}" },
        { type = "delve", name = "Paquete", request = "launch", program = "${fileDirname}" },
        { type = "delve", name = "Test del fichero", request = "launch", mode = "test", program = "${file}" },
        { type = "delve", name = "Test del paquete", request = "launch", mode = "test", program = "${fileDirname}" },
      }

      -- Abrir y cerrar los paneles con la sesión
      local view = require("dap-view")
      dap.listeners.before.attach["dap-view"] = function() view.open() end
      dap.listeners.before.launch["dap-view"] = function() view.open() end
      dap.listeners.before.event_terminated["dap-view"] = function() view.close() end
      dap.listeners.before.event_exited["dap-view"] = function() view.close() end
    end,
  },

  {
    "igorlfs/nvim-dap-view",
    lazy = true,
    opts = {},
  },
}
