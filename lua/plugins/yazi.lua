return {
  "mikavilpas/yazi.nvim",
  version = "*",
  cmd = "Yazi",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    open_file_function = function(chosen_file)
      if vim.fn.isdirectory(chosen_file) == 1 then
        return
      end

      vim.cmd.tabedit(vim.fn.fnameescape(chosen_file))
    end,
  },
}
