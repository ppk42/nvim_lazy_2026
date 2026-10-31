return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("dap-python").setup("debugpy-adapter")
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"mfussenegger/nvim-dap",
			"mason-org/mason.nvim",
		},
		opts = {
			ensure_installed = { "python", "js" },
			handlers = {
				python = function() end,
				js = function() end,
			},
		},
	},
	{
		"mxsdev/nvim-dap-vscode-js",
		ft = {
			"javascript",
			"typescript",
		},
		dependencies = {
			"mfussenegger/nvim-dap",
			"mason-org/mason.nvim",
		},
		config = function()
			local dap_session = require("dap.session")
			local dap_connect = dap_session.connect
			dap_session.connect = function(first, ...)
				if first == dap_session then
					local adapter, config, on_connect = ...
					return dap_connect(adapter, config, {}, on_connect)
				end
				return dap_connect(first, ...)
			end

			local js_utils = require("dap-vscode-js.utils")
			local start_js_debugger = js_utils.start_debugger
			js_utils.start_debugger = function(config, on_launch, ...)
				return start_js_debugger(config, function(output, proc)
					local port = output:match("Debug server listening at [^:]+:(%d+)")
						or output:match("^%s*(%d+)%s*$")
					on_launch(port or output, proc)
				end, ...)
			end

			require("dap-vscode-js").setup({
				debugger_cmd = {
					"js-debug-adapter",
					"0",
					"127.0.0.1",
				},
				adapters = {
					"pwa-node",
				},
			})

			local dap = require("dap")
			local node_adapter = dap.adapters["pwa-node"]
			dap.adapters["pwa-node"] = function(callback, config, parent)
				if parent then
					callback(vim.deepcopy(parent.adapter))
				else
					node_adapter(callback, config)
				end
			end

			local node_config = {
				{
					name = "Node.js: aktuelle Datei starten",
					type = "pwa-node",
					request = "launch",
					program = "${file}",
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					console = "integratedTerminal",
				},
			}
			local attach_config = {
				{
					name = "Node.js: an laufenden Prozess anhängen",
					type = "pwa-node",
					request = "attach",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					sourceMaps = true,
				},
			}

			dap.configurations.javascript = vim.deepcopy(node_config)
			vim.list_extend(dap.configurations.javascript, vim.deepcopy(attach_config))
			dap.configurations.typescript = vim.deepcopy(attach_config)
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		opts = {
			controls = {
				enabled = true,
			},
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.5 },
						{ id = "breakpoints", size = 0.15 },
						{ id = "stacks", size = 0.2 },
						{ id = "watches", size = 0.15 },
					},
					size = 36,
					position = "left",
				},
				{
					elements = { "repl" },
					size = 12,
					position = "bottom",
				},
			},
		},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			local function close_dap_ui_when_idle()
				if dap.session() then
					return
				end
				dapui.close()
				require("config.keymaps").detach_dap_session()
			end

			dap.listeners.on_session.dapui = function(_, session)
				if not session then
					close_dap_ui_when_idle()
				end
			end
			dap.listeners.after.event_initialized.dapui = function()
				dapui.open()
				require("config.keymaps").attach_dap_session()
			end
			dap.listeners.after.event_terminated.dapui = close_dap_ui_when_idle
			dap.listeners.after.event_exited.dapui = function(session)
				if not session.closed then
					session:close()
				end
				close_dap_ui_when_idle()
			end
			dap.listeners.after.disconnect.dapui = close_dap_ui_when_idle
			dap.listeners.after.terminate.dapui = close_dap_ui_when_idle

			dapui.setup(opts)
		end,
	},
}
