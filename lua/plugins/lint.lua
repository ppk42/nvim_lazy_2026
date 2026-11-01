return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      bash = { "shellcheck" },
      sh = { "shellcheck" },
    }

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
      callback = function(event)
        lint.try_lint(nil, { bufnr = event.buf })
      end,
    })
  end,
}
