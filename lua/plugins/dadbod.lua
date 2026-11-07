return {
  "kristijanhusak/vim-dadbod-ui",
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
    "DBUIRenameBuffer",
    "DBUILastQueryInfo",
  },
  dependencies = {
    { "tpope/vim-dadbod", cmd = "DB" },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_execute_on_save = 0
    vim.g.db_ui_auto_execute_table_helpers = 0
    vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod-ui"
  end,
}
