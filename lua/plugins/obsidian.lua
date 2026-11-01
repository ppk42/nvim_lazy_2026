return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  cmd = "Obsidian",
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    legacy_commands = false,
    callbacks = {
      enter_note = function()
        vim.keymap.set("n", "gf", "<cmd>Obsidian follow_link<cr>", {
          buffer = true,
          desc = "Wiki-Link folgen",
        })
      end,
    },
    picker = {
      name = "telescope.nvim",
    },
    workspaces = {
      {
        name = "DAFIS",
        path = "/home/pkiefer/11_Notes/obsidian/DAFIS",
      },
    },
  },
  keys = {
    {
      "<leader>mn",
      "<cmd>Obsidian new<cr>",
      desc = "Wiki-Notiz erstellen",
    },
    {
      "<leader>ms",
      "<cmd>Obsidian quick_switch<cr>",
      desc = "Wiki-Notiz öffnen",
    },
    {
      "<leader>mf",
      "<cmd>Obsidian search<cr>",
      desc = "Wiki durchsuchen",
    },
    {
      "<leader>mw",
      "<cmd>Obsidian workspace<cr>",
      desc = "Wiki-Workspace wechseln",
    },
  },
}
