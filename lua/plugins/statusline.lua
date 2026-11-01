return {
	"rebelot/heirline.nvim",
	lazy = false,
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

		local closed_tab_buffers = {}

		local function capture_tab_buffers()
			for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
				local buffers = {}
				for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
					buffers[vim.api.nvim_win_get_buf(win)] = true
				end
				closed_tab_buffers[vim.api.nvim_tabpage_get_number(tabpage)] = buffers
			end
		end

		capture_tab_buffers()
		vim.api.nvim_create_autocmd({ "BufEnter", "TabEnter" }, {
			callback = capture_tab_buffers,
		})
		vim.api.nvim_create_autocmd("TabClosedPre", {
			callback = function()
				local buffers = {}
				local tabpage = vim.api.nvim_get_current_tabpage()
				for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
					buffers[vim.api.nvim_win_get_buf(win)] = true
				end
				closed_tab_buffers[vim.api.nvim_tabpage_get_number(tabpage)] = buffers
			end,
		})
		vim.api.nvim_create_autocmd("TabClosed", {
			callback = function(event)
				local closed = closed_tab_buffers[tonumber(event.match)] or {}
				for buf in pairs(closed) do
					local visible = false
					for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
						for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
							if vim.api.nvim_win_get_buf(win) == buf then
								visible = true
								break
							end
						end
						if visible then
							break
						end
					end
					if not visible and vim.api.nvim_buf_is_valid(buf) then
						vim.bo[buf].buflisted = false
					end
				end
				closed_tab_buffers = {}
				capture_tab_buffers()
				vim.cmd.redrawtabline()
			end,
		})

		local function file_buffers()
			local buffers = {}
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if
					vim.api.nvim_buf_is_loaded(buf)
					and vim.bo[buf].buftype == ""
					and (vim.bo[buf].buflisted or vim.bo[buf].modified)
				then
					table.insert(buffers, buf)
				end
			end
			return buffers
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

		local buffer = {
			provider = function(self)
				local name = file_name(self.bufnr):gsub("%%", "%%%%")
				local icon = devicons.get_icon(name, nil, {
					default = true,
				})
				local modified = vim.bo[self.bufnr].modified and " ●" or ""
				return " " .. (icon and icon .. " " or "") .. name .. modified .. " "
			end,
			hl = function(self)
				return self.is_active and "TabLineSel" or "TabLine"
			end,
			on_click = {
				callback = function(_, bufnr)
					vim.api.nvim_win_set_buf(0, bufnr)
				end,
				minwid = function(self)
					return self.bufnr
				end,
				name = "heirline_switch_buffer",
			},
		}

		require("heirline").setup({
			opts = {
				disable_winbar_cb = function(args)
					return vim.bo[args.buf].buftype ~= ""
				end,
			},
			winbar = {
				condition = function()
					return vim.api.nvim_buf_get_name(0) ~= ""
				end,
				provider = function()
					local path = vim.api.nvim_buf_get_name(0):gsub("%%", "%%%%")
					return "%< " .. path
				end,
				hl = "WinBar",
			},
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
				utils.make_buflist(buffer, {
					provider = " … ",
				}, {
					provider = " … ",
				}, file_buffers, false),
			},
		})
	end,
}
