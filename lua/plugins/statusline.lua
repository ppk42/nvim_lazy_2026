return {
  "rebelot/heirline.nvim",
  event = "VeryLazy",
  dependencies = {
    {
      "nvim-tree/nvim-web-devicons",
      opts = {},
    },
  },
  config = function()
    local devicons = require("nvim-web-devicons")
    local utils = require("heirline.utils")

    local mode_names = {
      n = "NORMAL",
      i = "INSERT",
      v = "VISUAL",
      V = "VISUAL",
      R = "REPLACE",
      c = "COMMAND",
      t = "TERMINAL",
    }

    local mode_groups = {
      n = "Function",
      i = "String",
      v = "Special",
      V = "Special",
      R = "Error",
      c = "Identifier",
      t = "Identifier",
    }

    local function current_mode()
      return vim.fn.mode():sub(1, 1)
    end

    local function file_name(buf)
      local name = vim.api.nvim_buf_get_name(buf)
      if name == "" then
        return "[Ohne Namen]"
      end
      return vim.fn.fnamemodify(name, ":t")
    end

    local mode = {
      provider = function()
        local name = mode_names[current_mode()] or vim.fn.mode()
        return " " .. name .. " "
      end,
      hl = function()
        local group = mode_groups[current_mode()] or "Statement"
        return {
          fg = vim.api.nvim_get_hl(0, {
            name = group,
          }).fg,
          bold = true,
        }
      end,
    }

    local file_icon = {
      provider = function()
        local icon = devicons.get_icon(file_name(0), nil, {
          default = true,
        })
        return icon and " " .. icon or ""
      end,
      hl = function()
        local _, color = devicons.get_icon_color(file_name(0), nil, {
          default = true,
        })
        return {
          fg = color,
        }
      end,
    }

    local filename = {
      provider = function()
        local name = file_name(0):gsub("%%", "%%%%")
        if vim.bo.modified then
          name = name .. " ●"
        end
        if vim.bo.readonly then
          name = name .. " "
        end
        return " " .. name .. " "
      end,
      hl = {
        bold = true,
      },
    }

    local filetype = {
      provider = function()
        local name = vim.bo.filetype
        return name ~= "" and " " .. name .. " " or ""
      end,
    }

    local tab = {
      provider = function(self)
        local win = vim.api.nvim_tabpage_get_win(self.tabpage)
        local buf = vim.api.nvim_win_get_buf(win)
        local name = file_name(buf):gsub("%%", "%%%%")
        local modified = vim.bo[buf].modified and " ●" or ""
        return " " .. self.tabnr .. " " .. name .. modified .. " "
      end,
      hl = function(self)
        return self.is_active and "TabLineSel" or "TabLine"
      end,
      on_click = {
        callback = function(_, tabnr)
          vim.cmd.tabnext(tabnr)
        end,
        minwid = function(self)
          return self.tabnr
        end,
        name = "heirline_switch_tab",
      },
    }

    require("heirline").setup({
      statusline = {
        hl = "StatusLine",
        mode,
        file_icon,
        filename,
        {
          provider = "%=",
        },
        filetype,
        {
          provider = " %p%% ",
        },
        {
          provider = " %l:%c ",
        },
      },
      tabline = {
        hl = "TabLineFill",
        utils.make_tablist(tab),
        {
          provider = "%=",
        },
      },
    })
  end,
}
