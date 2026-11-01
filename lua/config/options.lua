vim.opt.expandtab = true
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.softtabstop = 3
vim.opt.wrap = false
vim.opt.textwidth = 78
vim.opt.formatoptions:remove({
  "t",
  "c",
})
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.showtabline = 2
vim.opt.laststatus = 3

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.conceallevel = 0
		vim.opt_local.spell = true
		vim.opt_local.spelllang = { "de", "en" }
	end,
})
