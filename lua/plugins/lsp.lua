return {
  "mason-org/mason-lspconfig.nvim",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  cmd = "Mason",
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = {},
    },
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.lsp.config("pyright", {
      capabilities = capabilities,
    })
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
            },
          },
        },
      },
    })

    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "󰌵",
        },
      },
      underline = false,
      virtual_text = false,
      virtual_lines = false,
      update_in_insert = false,
      severity_sort = true,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        require("config.keymaps").attach_lsp(event.buf)
      end,
    })

    require("mason-lspconfig").setup({
      ensure_installed = {
        "pyright",
        "lua_ls",
      },
      automatic_enable = {
        "pyright",
        "lua_ls",
      },
    })
  end,
}
