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
        python = { "black" },
        lua = { "stylua" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        bash = { "shfmt" },
        sh = { "shfmt" },
      },
      default_format_opts = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
      format_on_save = {},
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "black",
        "stylua",
        "prettier",
        "shfmt",
        "shellcheck",
      },
    },
  },
}
