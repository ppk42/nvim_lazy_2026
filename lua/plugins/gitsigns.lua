return {
	"lewis6991/gitsigns.nvim",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	opts = function()
		return {
			on_attach = function(buf)
				require("config.keymaps").attach_gitsigns(buf)
			end,
		}
	end,
}
