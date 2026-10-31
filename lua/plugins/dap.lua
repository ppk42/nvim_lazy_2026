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
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
		dependencies = {
			"mfussenegger/nvim-dap",
			"mason-org/mason.nvim",
		},
		config = function()
			require("dap-vscode-js").setup({
				debugger_cmd = { "js-debug-adapter" },
				adapters = {
					"pwa-node",
					"pwa-chrome",
				},
			})

			local dap = require("dap")
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
			local vite_config = {
				name = "Vite: Chrome (localhost:5173)",
				type = "pwa-chrome",
				request = "launch",
				url = "http://localhost:5173",
				webRoot = "${workspaceFolder}",
				sourceMaps = true,
			}

			for _, filetype in ipairs({ "javascript", "javascriptreact" }) do
				dap.configurations[filetype] = vim.deepcopy(node_config)
				table.insert(dap.configurations[filetype], vim.deepcopy(vite_config))
			end
			for _, filetype in ipairs({ "typescript", "typescriptreact" }) do
				dap.configurations[filetype] = { vim.deepcopy(vite_config) }
			end
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

			dap.listeners.after.event_initialized.dapui = function()
				dapui.open()
				require("config.keymaps").attach_dap_session()
			end
			dap.listeners.before.event_terminated.dapui = function()
				dapui.close()
				require("config.keymaps").detach_dap_session()
			end
			dap.listeners.before.event_exited.dapui = function()
				dapui.close()
				require("config.keymaps").detach_dap_session()
			end

			dapui.setup(opts)
		end,
	},
}
