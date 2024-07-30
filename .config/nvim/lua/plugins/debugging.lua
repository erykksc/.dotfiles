return {
	{
		"microsoft/vscode-js-debug",
		lazy = true,
		-- build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- Creates a beautiful debugger UI
			"rcarriga/nvim-dap-ui",

			-- Required dependency for nvim-dap-ui
			"nvim-neotest/nvim-nio",

			-- Installs the debug adapters for you
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",

			-- Add your own debuggers here
			"leoluz/nvim-dap-go",
			"mxsdev/nvim-dap-vscode-js",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("mason-nvim-dap").setup({
				-- Makes a best effort to setup the various debuggers with
				-- reasonable debug configurations
				automatic_installation = true,

				-- You can provide additional configuration to the handlers,
				-- see mason-nvim-dap README for more information
				handlers = {},

				-- You'll need to check that you have the required things installed
				-- online, please don't ask me how to install them :)
				ensure_installed = {
					-- Update this to ensure that you have the debuggers for the langs you want
					"delve",
					"js-debug-adapter",
					"debugpy",
				},
			})

			-- Basic debugging keymaps, feel free to change to your liking!
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
			-- vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			-- vim.keymap.set("n", "<leader>dB", function()
			-- 	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			-- end, { desc = "Debug: Set Breakpoint" })
			-- vim.keymap.set("n", "<leader>dl", function()
			-- 	dap.set_logpoint(vim.fn.input("Logpoint message: "))
			-- end, { desc = "Debug: Set Logpoint" })
			vim.keymap.set("n", "<Leader>b", function()
				require("dap").toggle_breakpoint()
			end, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<Leader>B", function()
				require("dap").set_breakpoint()
			end, { desc = "Debug: Set Breakpoint" })
			vim.keymap.set("n", "<Leader>L", function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, { desc = "Debug: Set Logpoint" })
			vim.keymap.set("n", "<Leader>dr", function()
				require("dap").repl.open()
			end, { desc = "Debug: Open REPL" })
			vim.keymap.set("n", "<Leader>dl", function()
				require("dap").run_last()
			end, { desc = "Debug: Run Last" })
			vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
				require("dap.ui.widgets").hover()
			end, { desc = "Debug: Hover" })
			vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
				require("dap.ui.widgets").preview()
			end, { desc = "Debug: Preview" })
			vim.keymap.set("n", "<Leader>df", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end, { desc = "Debug: Centered Float Frames" })
			vim.keymap.set("n", "<Leader>ds", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end, { desc = "Debug: Centered Float Scopes" })
			-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
			vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

			local sign = vim.fn.sign_define

			sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
			sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

			-- Dap UI setup
			-- For more information, see |:help nvim-dap-ui|
			---@diagnostic disable-next-line: missing-fields
			dapui.setup({
				controls = {
					element = "repl",
					enabled = true,
					icons = {
						disconnect = "",
						pause = "",
						play = "",
						run_last = "",
						step_back = "",
						step_into = "",
						step_out = "",
						step_over = "",
						terminate = "",
					},
				},
			})

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

			-- Install golang specific config
			require("dap-go").setup({
				dap_configurations = {
					-- If you want to use default go debug settings, you can put it in the root of the project
					-- and use the following configuration
					{
						type = "go",
						name = "Debug main.go",
						request = "launch",
						program = "./main.go",
					},
				},
				delve = {
					-- On Windows delve must be run attached or it crashes.
					-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
					detached = vim.fn.has("win32") == 0,
				},
			})

			require("dap-vscode-js").setup({
				-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
				-- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
				debugger_path = "/Users/erykksc/.local/share/nvim/lazy/vscode-js-debug",
				-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
				adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
				-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
				-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
				-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
			})

			for _, language in ipairs({ "typescript", "javascript" }) do
				require("dap").configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
				}
			end
		end,
	},
}
