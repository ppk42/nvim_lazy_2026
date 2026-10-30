vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set("n", "<leader>-", "<cmd>Yazi<cr>", {
	desc = "Yazi-Dateibrowser öffnen",
})

vim.keymap.set("n", "<Tab>", "<cmd>tabnext<cr>", {
	desc = "Zum nächsten Tab wechseln",
})
vim.keymap.set("n", "<C-I>", "<C-I>", {
	desc = "In der Sprungliste vorwärts gehen",
	noremap = true,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function(event)
		local info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
		if info and info.loclist == 1 then
			return
		end

		vim.keymap.set("n", "<CR>", function()
			vim.cmd("cc " .. vim.fn.line("."))
			vim.cmd.cclose()
		end, {
			buffer = event.buf,
			desc = "Zur Diagnose springen und Quickfix schließen",
		})
	end,
})

local M = {
	which_key = {
		{
			"<leader>l",
			group = "LSP Befehle",
			mode = { "n", "x" },
		},
		{
			"<leader>ld",
			group = "Diagnosen",
			mode = { "n", "x" },
		},
		{
			"<leader>lg",
			group = "Springen zu ... ",
			mode = { "n", "x" },
		},
	},
	dashboard = {
		{
			icon = " ",
			key = "n",
			desc = "Neue Datei",
			action = ":ene",
		},
		{
			icon = "󰇥 ",
			key = "y",
			desc = "Datei mit Yazi öffnen",
			action = ":Yazi cwd",
		},
		{
			icon = "󰒲 ",
			key = "l",
			desc = "Lazy öffnen",
			action = ":Lazy",
		},
		{
			icon = "󰏗 ",
			key = "m",
			desc = "Mason öffnen",
			action = ":Mason",
		},
		{
			icon = " ",
			key = "q",
			desc = "Beenden",
			action = ":qa",
		},
	},
}

function M.completion(cmp, luasnip)
	return {
		["<C-Space>"] = cmp.mapping.complete(),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item({
					behavior = cmp.SelectBehavior.Select,
				})
			elseif luasnip.locally_jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item({
					behavior = cmp.SelectBehavior.Select,
				})
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<CR>"] = cmp.mapping(function(fallback)
			if not cmp.visible() then
				fallback()
			elseif cmp.get_selected_entry() then
				cmp.confirm({
					select = false,
				})
			else
				cmp.abort()
			end
		end, { "i", "s" }),
	}
end

function M.attach_lsp(buf)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, {
			buffer = buf,
			desc = desc,
		})
	end

	map("n", "<leader>lgd", vim.lsp.buf.definition, "Zur Definition springen")
	map("n", "<leader>lgr", vim.lsp.buf.references, "Referenzen anzeigen")
	map("n", "<leader>lr", vim.lsp.buf.rename, "Symbol umbenennen")
	map({ "n", "x" }, "<leader>lgra", vim.lsp.buf.code_action, "Code-Aktionen anzeigen")
	map("n", "<leader>lK", vim.lsp.buf.hover, "Symbolinformationen anzeigen")
	map("n", "<leader>ldz", function()
		vim.diagnostic.open_float({
			scope = "line",
			focusable = false,
			close_events = {
				"CursorMoved",
				"CursorMovedI",
				"InsertCharPre",
			},
		})
	end, "Diagnose der aktuellen Zeile anzeigen")
	map("n", "<leader>ldd", function()
		local diagnostics = vim.diagnostic.get(buf)
		vim.fn.setqflist({}, "r", {
			title = "Diagnosen: " .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t"),
			items = vim.diagnostic.toqflist(diagnostics),
		})
		vim.cmd.copen()
	end, "Diagnosen der aktuellen Datei anzeigen")
end

return M
