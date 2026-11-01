# Neovim-Konfiguration

Eine minimale, schrittweise erweiterte Neovim-Konfiguration mit `lazy.nvim`.
Installierte Plugins und benötigte Betriebssystem-Programme werden hier
dokumentiert.

## Plugins

- `lazy.nvim`: Plugin-Manager. Wird beim ersten Start automatisch installiert.
- `astrotheme`: Helles Farbschema `astrolight`.
- `snacks.nvim`: Dashboard beim Start ohne Datei.
- `yazi.nvim`: Dateibrowser.
- `toggleterm.nvim`: Terminals direkt in Neovim.
- `telescope.nvim`: Fuzzy-Suche in Dateien, Buffer, Hilfe, Text, Git und mehr.
- `todo-comments.nvim`: TODO-Kommentare mit Telescope durchsuchen.
- `nvim-dap`, `nvim-dap-python` und `nvim-dap-ui`: Python- und
  JavaScript-Debugging.
- `mason-nvim-dap.nvim`: Installiert `debugpy` und `js-debug-adapter`.
- `nvim-dap-vscode-js`: Node.js-Debugging für JavaScript und TypeScript.
- `plenary.nvim`: Abhängigkeit von `yazi.nvim` und `telescope.nvim`.
- `which-key.nvim`: Zeigt mögliche Folgetasten nach dem Leader an.
- `lazygit.nvim`: Öffnet die Git-Oberfläche LazyGit mit `<leader>gl`.
- `gitsigns.nvim`: Zeigt Git-Änderungen am Rand und bietet lokale Aktionen.
- `mason.nvim`: Installiert externe Sprachserver.
- `mason-lspconfig.nvim`: Verbindet Mason mit Neovims LSP.
- `nvim-lspconfig`: Stellt die LSP-Konfigurationen bereit.
- `nvim-cmp` und `cmp-nvim-lsp`: Manuell aufgerufene LSP-Vervollständigung.
- `LuaSnip`, `cmp_luasnip` und `friendly-snippets`: Snippets für Python,
  Lua, JavaScript, TypeScript und React, die nur nach Auswahl eingefügt
  werden.
- `tsc.nvim`: TypeScript-Projektprüfungen mit `<leader>lT`.
- `package-info.nvim`: Versionsinformationen und Aktionen in `package.json`.
- `markdown-preview.nvim`: Markdown-Dateien im Browser anzeigen.
- `obsidian.nvim`: Obsidian-Vaults als Markdown-Wikis verwalten.
- `conform.nvim`: Markdown, HTML, CSS und Bash beim Speichern formatieren.
- `nvim-lint`: Bash-Dateien mit ShellCheck prüfen.
- `heirline.nvim` und `nvim-web-devicons`: Status- und Tab-Leiste.

### Yazi

`<leader>-` öffnet Yazi an der aktuellen Datei. Das Dashboard startet mit
`f` die Telescope-Dateisuche.

### Terminals

`<leader>tf`, `<leader>th` und `<leader>tv` öffnen ein schwebendes,
horizontal geteiltes oder vertikal geteiltes Terminal. `<leader>tn` startet
Node.js, `<leader>tp` Python und `<leader>te` nnn. Die Programme werden
anhand des `PATH` der Neovim-Sitzung aufgelöst.

### Tabs

Links zeigt die Leiste geladene Datei-Buffer. Auch durch LSP-Rename
geänderte, nicht gelistete Buffer erscheinen dort mit `●`. Ein Klick
wählt den Buffer; `<leader>c` schließt den aktiven Buffer und fragt bei
ungespeicherten Änderungen nach. Rechts stehen die echten Neovim-Tabs
mit Nummer und Dateinamen ohne Verzeichnispfad. Im Normalmodus wechselt
`<Tab>` zum nächsten Tab; `<C-I>` geht in der Sprungliste vorwärts.

## LSP, Vervollständigung und Snippets

Mason installiert `pyright` für Python, `lua_ls` für Lua und `vtsls` für
JavaScript und TypeScript beim ersten Öffnen einer Datei automatisch.
VTSLS aktiviert Inlay-Hints und aktualisiert Imports nach Datei-Umzügen.
Vorschläge erscheinen nur nach
`<C-Space>`.
Mit `<Tab>` und `<S-Tab>` wird ein Vorschlag gewählt oder zwischen
Snippet-Platzhaltern gewechselt. `<CR>` übernimmt nur einen gewählten
Vorschlag. Ohne Auswahl schließt es die Vorschlagsliste.

`<leader>lgd` springt zur Definition. `<leader>lgrr` zeigt Referenzen,
`<leader>lgrn` benennt um, `<leader>lgra` öffnet Code-Aktionen und
`<leader>lK` zeigt Informationen zum Symbol.
`<leader>ld` zeigt Diagnosen der aktuellen Zeile in einem Fenster, das
bei Cursorbewegung verschwindet. Sonst sind nur Markierungen am Rand
sichtbar. `<leader>le` zeigt die Diagnosen der aktuellen Datei in der
Quickfix-Liste. `<CR>` springt zur gewählten Stelle und schließt die Liste.
`<leader>lgra` bietet an der Fehlerstelle Korrekturen an. Relative
Zeilennummern sind aktiviert.

## Markdown, HTML, CSS und Bash

Mason installiert `marksman` für Markdown, `html` für HTML5, `cssls` für CSS
und `bashls` für Bash. Die Server verwenden die vorhandene LSP-
Vervollständigung und Diagnoseanzeige. Markdown wird auf Deutsch und Englisch
auf Rechtschreibung geprüft; `<leader>mp` öffnet oder schließt die
Browser-Vorschau und zeigt ihre lokale URL an.

Beim Speichern formatieren Prettier Markdown, HTML und CSS. `shfmt` formatiert
Bash mit zwei Leerzeichen Einrückung. ShellCheck zeigt Bash-Diagnosen nach dem
Öffnen und Speichern. `<leader>br` führt die gespeicherte Bash-Datei in einem
schwebenden Terminal aus.

## Obsidian-Wiki

`obsidian.nvim` verwendet `/home/pkiefer/11_Notes/obsidian/DAFIS` als Workspace
`DAFIS`. `<leader>mn` erstellt eine Notiz, `<leader>ms` öffnet eine per Namen
ausgewählte Notiz, `<leader>mf` durchsucht den Vault und `<leader>mw` wechselt
den Workspace. Mit `gf` auf einem Markdown-Link wird diesem gefolgt.
Weitere Vaults lassen sich in `lua/plugins/obsidian.lua` unter `workspaces`
eintragen und anschließend über `<leader>mw` auswählen. Der Pfad des
eingetragenen Workspaces kann dort jederzeit angepasst werden.

## Python-Debugging

`<leader>db` setzt oder entfernt einen Breakpoint. `<leader>dc` startet
oder setzt das Debugging fort; dabei kann die Konfiguration `file` gewählt
werden. F10 geht zum nächsten Schritt, F11 springt in eine Funktion und
Shift+F11 springt aus ihr heraus. `<leader>dQ` beendet die Sitzung und ist nur
während einer aktiven Sitzung verfügbar. Während der Debugger verbunden ist,
schaltet `<leader>du` die Oberfläche um.
Die Fokus- und Größen-Keymaps sind ebenfalls nur dann aktiv.
`<leader>ds`, `<leader>df`,
`<leader>dp` und `<leader>dw` fokussieren Variablen, Stack Frames, Breakpoints
und Watches. `<leader>dr` fokussiert die REPL und startet die Eingabe.
Im Visual-Modus wertet `<leader>dE` die Auswahl aus. Mason installiert
`debugpy` automatisch.
F5 setzt das Debugging fort.
In DAP-Bereichen ändern Ctrl-Pfeiltasten die Fenstergröße.

## JavaScript- und TypeScript-Debugging

In JavaScript-Dateien startet `<leader>dc` die aktuelle Datei direkt oder
setzt die Debug-Sitzung fort. Mit `<leader>da` kannst du dich an einen
laufenden Node.js-Prozess anhängen. Starte ihn dafür mit
`node --inspect-brk app.js`; Neovim fragt dann den Prozess ab. TypeScript
unterstützt den Attach-Pfad; zum Starten einer `.ts`-Datei ist ein
projektspezifischer TypeScript-Runner nötig.
Breakpoints und die DAP-Steuerung nutzen dieselben Tasten wie beim
Python-Debugging. Mason installiert `js-debug-adapter` automatisch.

`<leader>lT` führt den TypeScript-Projektcheck aus. In `package.json` zeigt
`package-info.nvim` Paketversionen und bietet Paketaktionen.

## Betriebssystem-Programme

- Neovim mit LuaJIT: Editor und Ausführung der Lua-Konfiguration.
- Git: Installation und Aktualisierung der Plugins mit `lazy.nvim`.
- LazyGit: Das Programm `lazygit` muss im System-PATH verfügbar sein.
- ripgrep (`rg`): schnelle Textsuche mit Neovim.
- curl: Netzwerkzugriffe über `vim.net.request()`.
- Node.js und npm: Installation und Ausführung von `pyright`.
- unzip: Entpacken von Sprachservern durch Mason.
- Eine Schrift mit Nerd-Font-Symbolen: Icons im Dashboard und in der
  Statuszeile.
- npm: Installation und Ausführung der Markdown-Vorschau.
- Yazi: Dateibrowser für `yazi.nvim`.
- Ein Öffner für `vim.ui.open()`: unter Linux `xdg-open`; je nach Umgebung
  sind auch `wslview`, `explorer.exe` oder `lemonade` möglich.

## Erstellungs- und Testumgebung

| Bestandteil | Umgebung |
| --- | --- |
| Betriebssystem | EndeavourOS, Linux 7.2.11-arch1-1 |
| Terminal | Kitty 0.49.2 (`TERM=xterm-kitty`) |
| Shell | Bash 5.3.20 |
| Neovim | 0.12.6 |
| Lua | 5.1, LuaJIT 2.1.1792588164 |

### Telescope

Alle Suchlisten starten mit `<leader>f`. `<leader>ff` sucht Dateien,
`<leader>fg` durchsucht Text und `<leader>fb`, `<leader>fr` sowie
`<leader>fh` öffnen die Suche in Buffern, Registern und Hilfe. `<leader>fT`
sucht TODO-Kommentare; `<leader>fY` sucht Treesitter-Symbole. Weitere Picker
decken unter anderem Git, LSP, Diagnosen, Befehle, Marks, Optionen,
Quickfix- und Suchverlauf ab. Textsuche verwendet `rg`.

### Git

`<leader>gl` öffnet LazyGit. In Git-Dateien zeigt Gitsigns Änderungen am
Rand an. `<leader>ghp` zeigt einen Hunk, `<leader>ghs` staged ihn,
`<leader>ghu` nimmt ihn aus dem Index, `<leader>ghb` zeigt den Zeilenverlauf
und `<leader>ghd` öffnet den Diff. `<leader>ghn` und `<leader>ghN`
springen zwischen Änderungen.
