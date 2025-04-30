return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "mxsdev/nvim-dap-vscode-js",
  },
  config = function()
    local dap = require("dap")

    -- Some mappings to ease dap Use
    vim.keymap.set('n', '<F5>', function() dap.continue() end)
    vim.keymap.set('n', '<F3>', function() dap.restart() end)
    vim.keymap.set('n', '<F4>', function() dap.run_last() end)
    vim.keymap.set('n', '<F10>', function() dap.step_over() end)
    vim.keymap.set('n', '<F11>', function() dap.step_into() end)
    vim.keymap.set('n', '<F12>', function() dap.step_out() end)
    vim.keymap.set('n', '<F9>', function() dap.toggle_breakpoint() end)
    vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
    vim.keymap.set('n', '<leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)

    vim.g.dap_virtual_text = true

    dap.adapters.coreclr = {
      type = 'executable',
      command = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/netcoredbg/netcoredbg",
      args = { '--interpreter=vscode' },
    }

    dap.configurations.cs = {
      {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
        env = {
          DOTNET_ENVIRONMENT = "Development",
          ASPNETCORE_ENVIRONMENT = "Development",
        }
      },
    }

    local dapui = require('dapui')
    dapui.setup({})
    dap.listeners.before.attach["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.launch["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      --dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      --dapui.close()
    end

    dap.listeners.before['initialize']['dapui_config'] = function()
      print("Starting debug session");
    end

    vim.keymap.set('n', '<F6>', function()
      dap.terminate()
      dapui.close()
    end)
    vim.keymap.set('n', '<leader>K', function()
      dapui.eval()
      dapui.eval()
    end)
  end
}
