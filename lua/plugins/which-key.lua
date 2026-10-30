return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = require("config.keymaps").which_key,
  },
}
