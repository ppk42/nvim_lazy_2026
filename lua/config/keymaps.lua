vim.g.mapleader = " "
vim.g.maplocalleader = ","

local function map_telescope(lhs, picker, desc, mode)
	vim.keymap.set(mode or "n", lhs, function()
		require("telescope.builtin")[picker]()
	end, {
		desc = desc,
	})
end

local telescope_pickers = {
	{ "<leader>fa", "autocommands", "Autocommands suchen" },
	{ "<leader>fB", "builtin", "Telescope-Builtins suchen" },
	{ "<leader>ff", "find_files", "Dateien suchen" },
	{ "<leader>fg", "live_grep", "Text suchen" },
	{ "<leader>fw", "grep_string", "Wort unter Cursor suchen" },
	{ "<leader>fb", "buffers", "Buffer suchen" },
	{ "<leader>fr", "registers", "Register suchen" },
	{ "<leader>fh", "help_tags", "Hilfe durchsuchen" },
	{ "<leader>fo", "oldfiles", "Zuletzt geöffnete Dateien" },
	{ "<leader>fk", "keymaps", "Tastenkombinationen suchen" },
	{ "<leader>fCO", "commands", "Befehle suchen" },
	{ "<leader>fCH", "command_history", "Befehlshistorie suchen" },
	{ "<leader>fs", "search_history", "Suchhistorie durchsuchen" },
	{ "<leader>fm", "marks", "Markierungen suchen" },
	{ "<leader>fj", "jumplist", "Sprungliste durchsuchen" },
	{ "<leader>ft", "tags", "Tags durchsuchen" },
	{ "<leader>fct", "current_buffer_tags", "Tags im Buffer durchsuchen" },
	{ "<leader>fq", "quickfix", "Quickfix-Liste durchsuchen" },
	{ "<leader>fQ", "quickfixhistory", "Quickfix-Verlauf" },
	{ "<leader>fl", "loclist", "Ortsliste durchsuchen" },
	{ "<leader>fF", "filetypes", "Dateitypen suchen" },
	{ "<leader>fH", "highlights", "Highlights durchsuchen" },
	{ "<leader>fcs", "colorscheme", "Farbschema auswählen" },
	{ "<leader>fM", "man_pages", "Manpages durchsuchen" },
	{ "<leader>fp", "planets", "Telescope-Planeten ansehen" },
	{ "<leader>fy", "symbols", "Vordefinierte Symbole suchen" },
	{ "<leader>fv", "vim_options", "Neovim-Optionen suchen" },
	{ "<leader>fP", "pickers", "Telescope-Picker suchen" },
	{ "<leader>fR", "resume", "Letzte Suche fortsetzen" },
	{ "<leader>fLR", "reloader", "Lua-Module neu laden" },
	{ "<leader>fS", "spell_suggest", "Rechtschreibvorschläge" },
	{ "<leader>fT", "treesitter", "Treesitter-Symbole suchen" },
	{ "<leader>f/", "current_buffer_fuzzy_find", "Im Buffer suchen" },
	{ "<leader>fGf", "git_files", "Git-Dateien suchen" },
	{ "<leader>fGc", "git_commits", "Git-Commits suchen" },
	{ "<leader>fGC", "git_bcommits", "Buffer-Commits suchen" },
	{ "<leader>fGR", "git_bcommits_range", "Commits für Zeilen suchen", "x" },
	{ "<leader>fGb", "git_branches", "Git-Branches suchen" },
	{ "<leader>fGs", "git_status", "Git-Status durchsuchen" },
	{ "<leader>fGS", "git_stash", "Git-Stash durchsuchen" },
	{ "<leader>fLr", "lsp_references", "LSP-Referenzen suchen" },
	{ "<leader>fLd", "lsp_definitions", "LSP-Definitionen suchen" },
	{ "<leader>fLi", "lsp_implementations", "LSP-Implementierungen suchen" },
	{ "<leader>fLt", "lsp_type_definitions", "LSP-Typdefinitionen suchen" },
	{ "<leader>fLs", "lsp_document_symbols", "Symbole im Dokument suchen" },
	{ "<leader>fLS", "lsp_workspace_symbols", "LSP-Arbeitsbereichssymbole" },
	{ "<leader>fLw", "lsp_dynamic_workspace_symbols", "Dynamische LSP-Symbole" },
	{ "<leader>fLI", "lsp_incoming_calls", "Eingehende Aufrufe suchen" },
	{ "<leader>fLO", "lsp_outgoing_calls", "Ausgehende Aufrufe suchen" },
	{ "<leader>fLD", "diagnostics", "Diagnosen durchsuchen" },
}

for _, picker in ipairs(telescope_pickers) do
	map_telescope(picker[1], picker[2], picker[3], picker[4])
end

vim.keymap.set("n", "<leader>-", "<cmd>Yazi<cr>", {
	desc = "Yazi-Dateibrowser öffnen",
})

vim.keymap.set("n", "<Tab>", function()
	vim.cmd.bnext()
end, {
	desc = "Zum nächsten Buffer-Tab wechseln",
})
vim.keymap.set("n", "<S-Tab>", function()
	vim.cmd.bprevious()
end, {
	desc = "Zum vorherigen Buffer-Tab wechseln",
})
vim.keymap.set("n", "<C-I>", "<C-I>", {
	desc = "In der Sprungliste vorwärts gehen",
	noremap = true,
})

vim.keymap.set("n", "<leader>c", function()
	vim.cmd("confirm bdelete")
end, {
	desc = "Aktuellen Buffer schließen",
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
			"<leader>f",
			group = "Suchen",
			mode = { "n", "x" },
		},
		{
			"<leader>fG",
			group = "Git-Suche",
			mode = { "n", "x" },
		},
		{
			"<leader>fL",
			group = "LSP-Suche",
			mode = { "n", "x" },
		},
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
