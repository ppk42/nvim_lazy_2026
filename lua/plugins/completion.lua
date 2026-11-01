return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    {
      "L3MON4D3/LuaSnip",
      dependencies = {
        "rafamadriz/friendly-snippets",
      },
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load({
          include = {
            "python",
            "lua",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
        })
      end,
    },
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      completion = {
        autocomplete = false,
        completeopt = "menu,menuone,noinsert",
      },
      preselect = cmp.PreselectMode.None,
      confirmation = {
        get_commit_characters = function()
          return {}
        end,
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = require("config.keymaps").completion(cmp, luasnip),
      sources = {
        {
          name = "nvim_lsp",
        },
        {
          name = "luasnip",
        },
      },
    })
  end,
}
