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
}
