return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    opts = {
      formatters = {
        shfmt = {
          append_args = { "-i", "2" },
        },
      },
      formatters_by_ft = {
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        bash = { "shfmt" },
        sh = { "shfmt" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "prettier", "shfmt", "shellcheck" },
    },
  },
}
