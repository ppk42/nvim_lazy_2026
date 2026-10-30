# Neovim-Konfiguration

Eine minimale, schrittweise erweiterte Neovim-Konfiguration mit `lazy.nvim`.
Installierte Plugins und benötigte Betriebssystem-Programme werden hier
dokumentiert.

## Plugins

- `lazy.nvim`: Plugin-Manager. Wird beim ersten Start automatisch installiert.
- `astrotheme`: Helles Farbschema `astrolight`.
- `snacks.nvim`: Dashboard beim Start ohne Datei.
- `yazi.nvim`: Dateibrowser.
- `plenary.nvim`: Abhängigkeit von `yazi.nvim`.
- `which-key.nvim`: Zeigt mögliche Folgetasten nach dem Leader an.
- `mason.nvim`: Installiert externe Sprachserver.
- `mason-lspconfig.nvim`: Verbindet Mason mit Neovims LSP.
- `nvim-lspconfig`: Stellt die LSP-Konfigurationen bereit.
- `nvim-cmp` und `cmp-nvim-lsp`: Manuell aufgerufene LSP-Vervollständigung.
- `LuaSnip`, `cmp_luasnip` und `friendly-snippets`: Snippets für Python
  und Lua, die nur nach Auswahl eingefügt werden.
- `heirline.nvim` und `nvim-web-devicons`: Status- und Tab-Leiste.

### Yazi

`<leader>-` öffnet Yazi an der aktuellen Datei. Mit `y` auf dem Dashboard
startet Yazi im aktuellen Arbeitsverzeichnis. Bei beiden Startwegen wird
eine ausgewählte Datei in einem neuen Neovim-Tab geöffnet.

### Tabs

Die Tab-Leiste zeigt Tab-Nummern und Dateinamen ohne Verzeichnispfad.
Im Normalmodus wechselt `<Tab>` zum nächsten Tab; `<C-I>` geht
weiterhin in der Sprungliste vorwärts.

## LSP, Vervollständigung und Snippets

Mason installiert `pyright` für Python und `lua_ls` für Lua beim
ersten Öffnen einer Datei automatisch. Vorschläge erscheinen nur nach
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

## Betriebssystem-Programme

- Neovim mit LuaJIT: Editor und Ausführung der Lua-Konfiguration.
- Git: Installation und Aktualisierung der Plugins mit `lazy.nvim`.
- ripgrep (`rg`): schnelle Textsuche mit Neovim.
- curl: Netzwerkzugriffe über `vim.net.request()`.
- Node.js und npm: Installation und Ausführung von `pyright`.
- unzip: Entpacken von Sprachservern durch Mason.
- Eine Schrift mit Nerd-Font-Symbolen: Icons im Dashboard und in der
  Statuszeile.
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
