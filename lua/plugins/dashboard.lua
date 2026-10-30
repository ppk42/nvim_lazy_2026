return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        keys = require("config.keymaps").dashboard,
      },
    },
  },
}
