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
    notes_subdir = "01 New Files",
    new_notes_location = "notes_subdir",
    link = {
      auto_update = true,
    },
    daily_notes = {
      enabled = true,
      folder = "12 Journal/Daily",
      date_format = "YYYY-MM-DD",
      template = "Daily Note.md",
      workdays_only = false,
    },
    templates = {
      enabled = true,
      folder = "90 Organize/Templates",
      date_format = "YYYY-MM-DD",
      time_format = "HH:mm",
    },
    attachments = {
      folder = "80 Attachement",
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
}
