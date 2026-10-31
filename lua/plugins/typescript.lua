return {
	{
		"dmmulroy/tsc.nvim",
		cmd = "TSC",
		opts = {},
	},
	{
		"vuki656/package-info.nvim",
		event = "BufRead package.json",
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {},
	},
}
