vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set("n", "<leader>Du", function()
	require("config.dadbod").refresh()
	vim.cmd.DBUIToggle()
end, {
	desc = "Datenbank-Oberfläche umschalten",
})
vim.keymap.set("n", "<leader>Da", function()
	require("config.dadbod").add()
end, {
	desc = "Datenbankverbindung hinzufügen",
})
vim.keymap.set("n", "<leader>Df", "<cmd>DBUIFindBuffer<cr>", {
	desc = "SQL-Buffer einer Datenbank zuordnen",
})

vim.keymap.set({ "n", "x" }, "<leader>lf", function()
	require("conform").format()
end, {
	desc = "Code formatieren",
})

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
	{ "<leader>fY", "treesitter", "Treesitter-Symbole suchen" },
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

vim.keymap.set("n", "<leader>fT", "<cmd>TodoTelescope<cr>", {
	desc = "TODOs suchen",
})

vim.keymap.set("n", "<leader>-", "<cmd>Yazi<cr>", {
	desc = "Yazi-Dateibrowser öffnen",
})

vim.keymap.set("n", "<leader>gl", "<cmd>LazyGit<cr>", {
	desc = "LazyGit öffnen",
})

vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", {
	desc = "Terminal als Fenster öffnen",
})
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", {
	desc = "Terminal horizontal öffnen",
})
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", {
	desc = "Terminal vertikal öffnen",
})

local runtime_terminals = {}

local function toggle_runtime_terminal(name, commands)
	local command
	for _, candidate in ipairs(commands) do
		command = vim.fn.exepath(candidate)
		if command ~= "" then
			break
		end
	end

	if not command or command == "" then
		vim.notify(table.concat(commands, " oder ") .. " ist nicht im PATH", vim.log.levels.WARN)
		return
	end

	if not runtime_terminals[name] then
		local Terminal = require("toggleterm.terminal").Terminal
		runtime_terminals[name] = Terminal:new({
			cmd = command,
			hidden = true,
			on_exit = function()
				runtime_terminals[name] = nil
			end,
		})
	end

	runtime_terminals[name]:toggle()
end

vim.keymap.set("n", "<leader>tn", function()
	toggle_runtime_terminal("node", { "node" })
end, {
	desc = "Node.js-Terminal öffnen",
})
vim.keymap.set("n", "<leader>tp", function()
	toggle_runtime_terminal("python", { "python", "python3" })
end, {
	desc = "Python-Terminal öffnen",
})
vim.keymap.set("n", "<leader>te", function()
	toggle_runtime_terminal("nnn", { "nnn" })
end, {
	desc = "nnn-Dateimanager öffnen (e=Explorer)",
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

vim.keymap.set("n", "<leader>lT", "<cmd>TSC<cr>", {
	desc = "TypeScript-Projekt prüfen",
})

local obsidian_mappings = {
	{ "<leader>oC", "check", "Vault-Konfiguration prüfen" },
	{ "<leader>ot", "today", "Heutige Notiz öffnen" },
	{ "<leader>oy", "yesterday", "Gestrige Notiz öffnen" },
	{ "<leader>oY", "tomorrow", "Morgige Notiz öffnen" },
	{ "<leader>oD", "dailies", "Tagesnotizen durchsuchen" },
	{ "<leader>on", "new", "Wiki-Notiz erstellen" },
	{ "<leader>oo", "open", "Notiz in Obsidian öffnen" },
	{ "<leader>og", "tags", "Tags durchsuchen" },
	{ "<leader>op", "properties", "Eigenschaften durchsuchen" },
	{ "<leader>os", "search", "Wiki-Inhalte durchsuchen" },
	{ "<leader>oS", "sync", "Obsidian-Sync" },
	{ "<leader>oM", "new_from_template", "Notiz aus Vorlage erstellen" },
	{ "<leader>oq", "quick_switch", "Wiki-Notiz öffnen" },
	{ "<leader>oR", "rebuild_cache", "Wiki-Cache neu aufbauen" },
	{ "<leader>ow", "workspace", "Wiki-Workspace wechseln" },
	{ "<leader>oh", "help", "Obsidian-Hilfe öffnen" },
	{ "<leader>oH", "helpgrep", "Obsidian-Hilfe durchsuchen" },
	{ "<leader>oU", "unique_note", "Notiz mit eindeutiger ID erstellen" },
	{ "<leader>ob", "bookmarks", "Lesezeichen durchsuchen" },
	{ "<leader>oB", "backlinks", "Rückverweise anzeigen" },
	{ "<leader>oi", "template", "Vorlage in Notiz einfügen" },
	{ "<leader>oN", "link_new", "Aus Auswahl verknüpfte Notiz erstellen", "x" },
	{ "<leader>ol", "link", "Auswahl mit Notiz verknüpfen", "x" },
	{ "<leader>oL", "links", "Links in Notiz anzeigen" },
	{ "<leader>of", "follow_link", "Wiki-Link folgen" },
	{ "<leader>oc", "toggle_checkbox", "Checkbox umschalten", { "n", "x" } },
	{ "<leader>or", "rename", "Notiz umbenennen" },
	{ "<leader>oI", "paste_img", "Bild aus Zwischenablage einfügen" },
	{ "<leader>oE", "extract_note", "Auswahl als Notiz extrahieren", "x" },
	{ "<leader>oT", "toc", "Inhaltsverzeichnis der Notiz öffnen" },
	{ "<leader>oF", "footnotes", "Fußnoten der Notiz anzeigen" },
}

for _, mapping in ipairs(obsidian_mappings) do
	local command = "<cmd>Obsidian " .. mapping[2] .. "<cr>"
	vim.keymap.set(mapping[4] or "n", mapping[1], command, {
		desc = mapping[3],
	})
end

vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", {
	desc = "Markdown-Vorschau im Browser umschalten",
})

vim.api.nvim_create_autocmd("User", {
	pattern = "ObsidianNoteEnter",
	callback = function()
		vim.keymap.set("n", "gf", "<cmd>Obsidian follow_link<cr>", {
			buffer = true,
			desc = "Wiki-Link folgen",
		})
	end,
})

vim.keymap.set("n", "<leader>br", function()
	if vim.bo.filetype ~= "bash" and vim.bo.filetype ~= "sh" then
		vim.notify("Der aktuelle Buffer ist kein Bash-Skript", vim.log.levels.WARN)
		return
	end

	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		vim.notify("Bitte Bash-Datei zuerst speichern", vim.log.levels.WARN)
		return
	end

	local Terminal = require("toggleterm.terminal").Terminal
	Terminal:new({
		cmd = "bash " .. vim.fn.shellescape(path),
		direction = "float",
		close_on_exit = false,
	}):toggle()
end, {
	desc = "Bash-Datei ausführen",
})

vim.keymap.set("n", "<leader>db", function()
	require("dap").toggle_breakpoint()
end, {
	desc = "Breakpoint umschalten",
})

local function focus_dap_window(filetype, enter_insert)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == filetype then
			vim.api.nvim_set_current_win(win)
			if enter_insert then
				vim.cmd.startinsert()
			end
			return
		end
	end

	vim.notify("DAP-Bereich ist nicht geöffnet", vim.log.levels.WARN)
end

local function terminate_dap_session()
	local dap = require("dap")
	local function close_if_idle()
		if dap.session() then
			return
		end
		require("dapui").close()
		require("config.keymaps").detach_dap_session()
	end

	if not dap.session() and vim.tbl_isempty(dap.sessions()) then
		close_if_idle()
		return
	end

	dap.terminate({
		all = true,
		hierarchy = true,
		on_done = close_if_idle,
	})
end

vim.keymap.set("n", "<F5>", function()
	require("dap").continue()
end, {
	desc = "Debugging fortsetzen",
})
vim.keymap.set("n", "<F10>", function()
	require("dap").step_over()
end, {
	desc = "Debugger: nächster Schritt",
})
vim.keymap.set("n", "<F11>", function()
	require("dap").step_into()
end, {
	desc = "Debugger: hineinspringen",
})
vim.keymap.set("n", "<F23>", function()
	require("dap").step_out()
end, {
	desc = "Debugger: herausspringen",
})
vim.keymap.set("n", "<leader>dB", function()
	require("dap").clear_breakpoints()
end, {
	desc = "Breakpoints entfernen",
})

local function find_dap_configuration(name)
	local dap = require("dap")
	for _, config in ipairs(dap.configurations[vim.bo.filetype] or {}) do
		if config.name == name then
			return vim.deepcopy(config)
		end
	end
end

vim.keymap.set("n", "<leader>dc", function()
	local dap = require("dap")
	if dap.session() then
		dap.continue()
		return
	end

	local config = find_dap_configuration("Node.js: aktuelle Datei starten")
	if not config then
		vim.notify(
			"Keine Node.js-Startkonfiguration für " .. vim.bo.filetype,
			vim.log.levels.WARN
		)
		return
	end

	dap.run(config)
end, {
	desc = "Debugging starten oder fortsetzen",
})
vim.keymap.set("n", "<leader>da", function()
	local config = find_dap_configuration("Node.js: an laufenden Prozess anhängen")
	if not config then
		vim.notify("Keine Node.js-Attach-Konfiguration für " .. vim.bo.filetype, vim.log.levels.WARN)
		return
	end

	require("dap").run(config, { new = true })
end, {
	desc = "An laufenden Node.js-Prozess anhängen",
})
vim.keymap.set("n", "<leader>du", function()
	require("dapui").toggle()
end, {
	desc = "Debugger-Oberfläche umschalten",
})
vim.keymap.set("x", "<leader>dE", function()
	require("dapui").eval()
end, {
	desc = "Auswahl auswerten",
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
			"<leader>D",
			group = "Datenbanken",
			mode = { "n", "x" },
		},
		{ "<leader>Dq", group = "Abfragen", mode = { "n", "x" } },
		{ "<leader>Dr", group = "Ergebnisse" },
		{
			"<leader>d",
			group = "Debuggen",
			mode = { "n", "x" },
		},
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
			"<leader>g",
			group = "Git-Hunks",
			mode = { "n", "x" },
		},
		{ "<leader>gl", icon = { icon = "", color = "orange" } },
		{ "<leader>gp", icon = { icon = "", color = "orange" } },
		{ "<leader>gs", icon = { icon = "", color = "orange" } },
		{ "<leader>gu", icon = { icon = "", color = "orange" } },
		{ "<leader>gb", icon = { icon = "", color = "orange" } },
		{ "<leader>gd", icon = { icon = "", color = "orange" } },
		{ "<leader>gn", icon = { icon = "", color = "orange" } },
		{ "<leader>gN", icon = { icon = "", color = "orange" } },
		{
			"<leader>t",
			group = "Terminals",
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
			icon = " ",
			key = "f",
			desc = "Datei suchen",
			action = ":Telescope find_files",
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

function M.attach_dadbod(buf)
	local ft = vim.bo[buf].filetype
	if ft ~= "sql" and ft ~= "dbui" and ft ~= "dbout" then
		return
	end

	local function map(lhs, rhs, desc, mode)
		vim.keymap.set(mode or "n", "<leader>D" .. lhs, rhs, {
			buffer = buf,
			desc = desc,
		})
	end

	local function plug(lhs, action, desc, mode)
		map(lhs, "<Plug>(DBUI_" .. action .. ")", desc, mode)
	end

	local function remove(mode, lhs)
		pcall(vim.keymap.del, mode, lhs, { buffer = buf })
	end

	if ft == "sql" then
		if not vim.b[buf].dbui_db_key_name then
			return
		end
		plug("qe", "ExecuteQuery", "Abfrage ausführen", { "n", "x" })
		for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(buf, "n")) do
			if mapping.lhs == "<Plug>(DBUI_SaveQuery)" then
				plug("qs", "SaveQuery", "Abfrage speichern")
			end
		end
		plug("qp", "EditBindParameters", "Bind-Parameter bearbeiten")
		map("qr", "<cmd>DBUIRenameBuffer<cr>", "Abfrage umbenennen")
		map("qi", "<cmd>DBUILastQueryInfo<cr>", "Letzte Abfrage anzeigen")
	elseif ft == "dbui" then
		local function sidebar(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
		end
		local actions = {
			{ "o", "SelectLine", "Eintrag öffnen oder aufklappen" },
			{ "<CR>", "SelectLine", "Eintrag öffnen oder aufklappen" },
			{ "<2-LeftMouse>", "SelectLine", "Eintrag öffnen oder aufklappen" },
			{ "S", "SelectLineVsplit", "Eintrag vertikal öffnen" },
			{ "R", "Redraw", "Tabellenliste aktualisieren" },
			{ "H", "ToggleDetails", "Verbindungsherkunft anzeigen" },
			{ "q", "Quit", "Seitenleiste schließen" },
			{ "J", "GotoNextSibling", "Nächster Eintrag gleicher Ebene" },
			{ "K", "GotoPrevSibling", "Vorheriger Eintrag gleicher Ebene" },
			{ "<C-k>", "GotoFirstSibling", "Erster Eintrag gleicher Ebene" },
			{ "<C-j>", "GotoLastSibling", "Letzter Eintrag gleicher Ebene" },
			{ "<C-p>", "GotoParentNode", "Übergeordneter Eintrag" },
			{ "<C-n>", "GotoChildNode", "Untergeordneter Eintrag" },
		}
		for _, action in ipairs(actions) do
			sidebar(action[1], "<Plug>(DBUI_" .. action[2] .. ")", action[3])
		end
		sidebar("A", function()
			require("config.dadbod").add()
		end, "Datenbankverbindung hinzufügen")
		sidebar("d", function()
			require("config.dadbod").manage("delete")
		end, "Eintrag entfernen")
		sidebar("r", function()
			require("config.dadbod").manage("edit")
		end, "Eintrag bearbeiten oder umbenennen")
		sidebar("?", function()
			require("which-key").show({ global = false })
		end, "Navigationshilfe anzeigen")
	elseif ft == "dbout" then
		for _, mapping in ipairs(vim.api.nvim_buf_get_keymap(buf, "n")) do
			if mapping.lhs == "R" then
				local reload = mapping.rhs:match("(<SNR>%d+_reload)%(%)")
				if reload then
					map("rr", function()
						vim.fn[reload]()
					end, "Abfrage erneut ausführen")
					map("rl", function()
						vim.keymap.set("n", "R", mapping.rhs, { buffer = buf })
						local ok, err = pcall(function()
							vim.fn["db_ui#dbout#toggle_layout"]()
						end)
						remove("n", "R")
						if not ok then
							error(err)
						end
					end, "Ergebnisansicht ändern und Abfrage erneut ausführen")
				end
			elseif mapping.lhs == "r" then
				map("re", mapping.rhs, "Abfrage in Befehlszeile bearbeiten")
			end
		end
		for _, lhs in ipairs({ "R", "r", "q", "gq", "<C-C>" }) do
			remove("n", lhs)
		end
		remove("o", "ic")
		map("rc", "<cmd>call db#cancel()<cr>", "Abfrage abbrechen")
		map("rq", "<cmd>bdelete<cr>", "Ergebnis schließen")
		plug("rf", "JumpToForeignKey", "Fremdschlüssel abfragen")
		plug("rv", "YankCellValue", "Zellwert auswählen")
		plug("rh", "YankHeader", "Spaltenüberschriften kopieren")
		map("ry", function()
			vim.fn["db_ui#dbout#get_cell_value"]()
			vim.cmd('normal! y')
		end, "Zellwert kopieren")
	end
end

function M.completion(cmp, luasnip)
	return {
		["<C-Space>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_next_item({
					behavior = cmp.SelectBehavior.Select,
				})
			else
				cmp.complete()
			end
		end, { "i", "s" }),
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
	map({ "n", "x" }, "<leader>lga", vim.lsp.buf.code_action, "Code-Aktionen anzeigen")
	map("n", "<leader>lK", vim.lsp.buf.hover, "Symbolinformationen anzeigen")
	map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, "Funktionssignatur anzeigen")
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

function M.attach_gitsigns(buf)
	local function map(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, {
			buffer = buf,
			desc = desc,
		})
	end

	map("n", "<leader>gp", function()
		require("gitsigns").preview_hunk()
	end, "Änderung anzeigen")
	map("n", "<leader>gs", function()
		require("gitsigns").stage_hunk()
	end, "Änderung zum Index hinzufügen")
	map("v", "<leader>gs", function()
		local start_line = vim.fn.line(".")
		local end_line = vim.fn.line("v")
		require("gitsigns").stage_hunk({
			math.min(start_line, end_line),
			math.max(start_line, end_line),
		})
	end, "Auswahl zum Index hinzufügen")
	map("n", "<leader>gu", function()
		require("gitsigns").stage_hunk()
	end, "Änderung aus dem Index entfernen")
	map("n", "<leader>gb", function()
		require("gitsigns").blame_line({ full = true })
	end, "Zeilenverlauf anzeigen")
	map("n", "<leader>gd", function()
		require("gitsigns").diffthis()
	end, "Änderungen vergleichen")
	map("n", "<leader>gn", function()
		require("gitsigns").nav_hunk("next")
	end, "Nächste Änderung")
	map("n", "<leader>gN", function()
		require("gitsigns").nav_hunk("prev")
	end, "Vorherige Änderung")
end

local dap_session_maps_active = false
local dap_ui_map_keys = {
	"<leader>ds",
	"<leader>df",
	"<leader>dp",
	"<leader>dw",
	"<leader>dr",
	"<leader>dQ",
}
local dap_ui_resize_keys = {
	"<C-Up>",
	"<C-Down>",
	"<C-Left>",
	"<C-Right>",
}

function M.attach_dap_session()
	if dap_session_maps_active then
		return
	end

	dap_session_maps_active = true
	vim.keymap.set("n", "<leader>ds", function()
		focus_dap_window("dapui_scopes")
	end, {
		desc = "Zu Variablen wechseln",
	})
	vim.keymap.set("n", "<leader>df", function()
		focus_dap_window("dapui_stacks")
	end, {
		desc = "Zu Stack Frames wechseln",
	})
	vim.keymap.set("n", "<leader>dp", function()
		focus_dap_window("dapui_breakpoints")
	end, {
		desc = "Zu Breakpoints wechseln",
	})
	vim.keymap.set("n", "<leader>dw", function()
		focus_dap_window("dapui_watches")
	end, {
		desc = "Zu Watches wechseln",
	})
	vim.keymap.set("n", "<leader>dr", function()
		focus_dap_window("dap-repl", true)
	end, {
		desc = "REPL fokussieren und Eingabe starten",
	})
	vim.keymap.set("n", "<leader>dQ", function()
		terminate_dap_session()
	end, {
		desc = "Debugging beenden",
	})

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) then
			local filetype = vim.bo[buf].filetype
			if filetype:match("^dapui_") or filetype == "dap-repl" then
				vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", {
					buffer = buf,
					desc = "DAP-Bereich höher machen",
				})
				vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", {
					buffer = buf,
					desc = "DAP-Bereich niedriger machen",
				})
				vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -4<cr>", {
					buffer = buf,
					desc = "DAP-Bereich schmaler machen",
				})
				vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +4<cr>", {
					buffer = buf,
					desc = "DAP-Bereich breiter machen",
				})
			end
		end
	end
end

function M.detach_dap_session()
	if not dap_session_maps_active then
		return
	end

	dap_session_maps_active = false
	for _, lhs in ipairs(dap_ui_map_keys) do
		vim.keymap.del("n", lhs)
	end
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) then
			local filetype = vim.bo[buf].filetype
			if filetype:match("^dapui_") or filetype == "dap-repl" then
				for _, lhs in ipairs(dap_ui_resize_keys) do
					pcall(vim.keymap.del, "n", lhs, { buffer = buf })
				end
			end
		end
	end
end

return M
