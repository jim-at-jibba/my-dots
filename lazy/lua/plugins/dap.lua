return {

  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    enabled = false,
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
      --
      -- dap.adapters.go = function(callback, config)
      -- 	local stdout = vim.loop.new_pipe(false)
      -- 	local handle
      -- 	local pid_or_err
      -- 	local port = 38697
      -- 	local opts = {
      -- 		stdio = { nil, stdout },
      -- 		args = { "dap", "-l", "127.0.0.1:" .. port },
      -- 		detached = true,
      -- 	}
      -- 	handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
      -- 		stdout:close()
      -- 		handle:close()
      -- 		if code ~= 0 then
      -- 			print("dlv exited with code", code)
      -- 		end
      -- 	end)
      -- 	assert(handle, "Error running dlv: " .. tostring(pid_or_err))
      -- 	stdout:read_start(function(err, chunk)
      -- 		assert(not err, err)
      -- 		if chunk then
      -- 			vim.schedule(function()
      -- 				require("dap.repl").append(chunk)
      -- 			end)
      -- 		end
      -- 	end)
      -- 	-- Wait for delve to start
      -- 	vim.defer_fn(function()
      -- 		callback({ type = "server", host = "127.0.0.1", port = port })
      -- 	end, 100)
      -- end
      -- -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
      -- dap.configurations.go = {
      -- 	{
      -- 		type = "go",
      -- 		name = "Debug",
      -- 		request = "launch",
      -- 		program = "${file}",
      -- 	},
      -- 	{
      -- 		type = "go",
      -- 		name = "Debug test", -- configuration for debugging test files
      -- 		request = "launch",
      -- 		mode = "test",
      -- 		program = "${file}",
      -- 	},
      -- 	-- works with go.mod packages and sub packages
      -- 	{
      -- 		type = "go",
      -- 		name = "Debug test (go.mod)",
      -- 		request = "launch",
      -- 		mode = "test",
      -- 		program = "./${relativeFileDirname}",
      -- 	},
      -- }

      dap.adapters.node2 = {
        type = "executable",
        command = "node",
        args = { os.getenv("HOME") .. "/code/utils/vscode-node-debug2/out/src/nodeDebug.js" },
      }

      dap.configurations.javascript = {
        {
          name = "Launch",
          type = "node2",
          request = "launch",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
        },
        {
          -- For this to work you need to make sure the node process is started with the `--inspect` flag.
          name = "Attach to process",
          type = "node2",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
        {
          name = "React native",
          type = "node2",
          request = "attach",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
          port = 35000,
        },
      }

      dap.configurations.typescript = {
        {
          name = "React native",
          type = "node2",
          request = "attach",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
          port = 35000,
        },
      }

      dap.configurations.typescriptreact = {
        {
          name = "React native",
          type = "node2",
          request = "attach",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
          port = 35000,
        },
      }
    end,
  },
}
