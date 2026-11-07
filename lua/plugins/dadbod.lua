return {
  "kristijanhusak/vim-dadbod-ui",
  ft = { "sql", "dbout" },
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
    vim.g.db_ui_disable_mappings = 1
    vim.g.db_ui_show_help = 0
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_execute_on_save = 0
    vim.g.db_ui_auto_execute_table_helpers = 0
    vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod-ui"
    require("config.dadbod").setup()
  end,
  config = function()
    local group = vim.api.nvim_create_augroup("DadbodKeymaps", { clear = true })
    local function attach(event)
      local buf = event.buf
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
          require("config.keymaps").attach_dadbod(buf)
        end
      end)
    end

    vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "BufReadPost" }, {
      group = group,
      callback = attach,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "DBUIOpened",
      callback = function()
        require("config.dadbod").refresh()
        require("config.keymaps").attach_dadbod(vim.api.nvim_get_current_buf())
      end,
    })
  end,
}
