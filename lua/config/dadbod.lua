local M = {}
local base_connections
local project_connections = {}

local function project_root()
  local cwd = vim.fn.getcwd()
  return vim.fs.root(cwd, { ".git", ".dadbod" }) or cwd
end

local function connection_file(root)
  return root .. "/.dadbod/connections.json"
end

local function report(message)
  vim.notify(message, vim.log.levels.ERROR)
end

function M.display_name(label, key)
  local project = project_connections[key]
  if not project then
    return label
  end
  return project.name .. label:sub(#project.internal_name + 1)
end

local function format_drawer()
  vim.cmd([=[
    let g:nvim_dadbod_drawer = db_ui#drawer#get()
    if !has_key(g:nvim_dadbod_drawer, 'project_original_add')
      let g:nvim_dadbod_drawer.project_original_add = g:nvim_dadbod_drawer.add
      function! g:nvim_dadbod_drawer.add(...) dict abort
        let args = copy(a:000)
        if args[2] ==# 'db'
          let args[0] = luaeval(
            \ "require('config.dadbod').display_name(_A[1], _A[2])",
            \ [args[0], args[4]])
        endif
        return call(self.project_original_add, args, self)
      endfunction
    endif
    unlet g:nvim_dadbod_drawer
  ]=])
end

local function read(root)
  local path = connection_file(root)
  if vim.fn.filereadable(path) == 0 then
    return {}
  end
  local ok, entries = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
  end)
  local names = {}
  if ok and type(entries) == "table" and vim.islist(entries) then
    for _, entry in ipairs(entries) do
      if
        type(entry) ~= "table"
        or type(entry.name) ~= "string"
        or vim.trim(entry.name) == ""
        or type(entry.url) ~= "string"
        or vim.trim(entry.url) == ""
        or names[entry.name:lower()]
      then
        ok = false
        break
      end
      names[entry.name:lower()] = true
    end
  else
    ok = false
  end
  if not ok then
    report("Ungültige Projektverbindungen in " .. path)
    return nil
  end
  return entries
end

function M.refresh()
  if not base_connections then
    return M.setup()
  end
  local root = project_root()
  local connections = vim.deepcopy(base_connections or {})
  project_connections = {}
  for _, entry in ipairs(read(root) or {}) do
    local name = "[Projekt " .. root .. "] " .. entry.name
    connections[#connections + 1] = { name = name, url = entry.url }
    project_connections[name .. "_g:dbs"] = {
      root = root,
      name = entry.name,
      internal_name = name,
    }
  end
  vim.g.dbs = connections
  if vim.fn.exists("*db_ui#drawer#get") == 1 then
    format_drawer()
    vim.cmd("call db_ui#drawer#get().render({'dbs': 1})")
  end
end

local function write(root, entries)
  local ok = pcall(function()
    vim.fn.mkdir(root .. "/.dadbod", "p")
    if
      vim.fn.writefile({ vim.json.encode(entries) }, connection_file(root))
      ~= 0
    then
      error("write failed")
    end
  end)
  if not ok then
    report("Projektverbindungen konnten nicht gespeichert werden")
    return
  end
  M.refresh()
end

local function edit(root, old_name)
  local entries = read(root)
  if not entries then
    return
  end
  local previous = {}
  for _, entry in ipairs(entries) do
    if entry.name == old_name then
      previous = entry
      break
    end
  end
  vim.ui.input(
    { prompt = "Verbindungsname: ", default = previous.name },
    function(name)
      if not name then
        return
      end
      name = vim.trim(name)
      if name == "" then
        return report("Der Verbindungsname darf nicht leer sein")
      end
      vim.ui.input(
        { prompt = "Verbindungs-URL: ", default = previous.url },
        function(url)
          if not url then
            return
          end
          url = vim.trim(url)
          local ok = url ~= ""
            and pcall(function()
              vim.fn["db#url#parse"](url)
              vim.fn["db#resolve"](url)
            end)
          if not ok then
            return report("Ungültige Verbindungs-URL")
          end
          local current = read(root)
          if not current then
            return
          end
          local result = {}
          for _, entry in ipairs(current) do
            if entry.name ~= old_name then
              if entry.name:lower() == name:lower() then
                return report("Dieser Verbindungsname ist bereits vergeben")
              end
              result[#result + 1] = entry
            end
          end
          result[#result + 1] = { name = name, url = url }
          write(root, result)
        end
      )
    end
  )
end

function M.add()
  require("lazy").load({ plugins = { "vim-dadbod-ui" } })
  local root = project_root()
  vim.ui.select({ "Global", "Projekt" }, {
    prompt = "Verbindung speichern:",
  }, function(choice)
    if choice == "Global" then
      vim.cmd.DBUIAddConnection()
    elseif choice == "Projekt" then
      edit(root)
    end
  end)
end

function M.manage(action)
  local item = vim.fn.eval("db_ui#drawer#get().get_current_item()")
  local project = project_connections[item.dbui_db_key_name]
  if item.type ~= "db" or not project then
    local method = action == "edit" and "rename_line" or "delete_line"
    vim.cmd("call db_ui#drawer#get()." .. method .. "()")
    return
  end
  if action == "edit" then
    return edit(project.root, project.name)
  end
  vim.ui.select({ "Abbrechen", "Entfernen" }, {
    prompt = "Projektverbindung " .. project.name .. " entfernen?",
  }, function(choice)
    if choice ~= "Entfernen" then
      return
    end
    local entries = read(project.root)
    if entries then
      entries = vim.tbl_filter(function(entry)
        return entry.name ~= project.name
      end, entries)
      write(project.root, entries)
    end
  end)
end

function M.setup()
  if base_connections then
    return
  end
  base_connections = {}
  local existing = vim.g.dbs or {}
  if vim.islist(existing) then
    base_connections = vim.deepcopy(existing)
  else
    for name, url in pairs(existing) do
      base_connections[#base_connections + 1] = { name = name, url = url }
    end
  end
  local group = vim.api.nvim_create_augroup("DadbodProjects", { clear = true })
  vim.api.nvim_create_autocmd("DirChanged", {
    group = group,
    callback = M.refresh,
  })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    pattern = "*/.dadbod/connections.json",
    callback = M.refresh,
  })
  M.refresh()
end

return M
