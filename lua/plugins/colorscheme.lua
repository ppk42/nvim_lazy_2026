return {
  "AstroNvim/astrotheme",
  lazy = false,
  priority = 1100,
  config = function()
    require("astrotheme").setup({})
    vim.cmd.colorscheme("astrolight")
  end,
}
