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
			ensure_installed = { "python" },
			handlers = {
				python = function() end,
			},
		},
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
