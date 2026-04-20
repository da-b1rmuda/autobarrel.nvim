local M = {}

function M.notify(msg, level)
  local config = require("autobarrel.config")
  if not config.options.notify then
    return
  end

  vim.notify("[autobarrel] " .. msg, level or vim.log.levels.INFO)
end

function M.tbl_contains(tbl, value)
  for _, v in ipairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

function M.ends_with(str, suffix)
  return suffix == "" or str:sub(-#suffix) == suffix
end

function M.basename(path)
  return vim.fs.basename(path)
end

function M.dirname(path)
  return vim.fs.dirname(path)
end

function M.is_windows()
  return package.config:sub(1, 1) == "\\"
end

function M.normalize(path)
  return vim.fs.normalize(path)
end

function M.joinpath(...)
  return M.normalize(table.concat({ ... }, "/"))
end

function M.path_exists(path)
  local stat = vim.uv.fs_stat(path)
  return stat ~= nil
end

function M.is_file(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == "file" or false
end

function M.is_dir(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == "directory" or false
end

function M.read_file(path)
  local fd = assert(vim.uv.fs_open(path, "r", 438))
  local stat = assert(vim.uv.fs_fstat(fd))
  local data = assert(vim.uv.fs_read(fd, stat.size, 0))
  assert(vim.uv.fs_close(fd))
  return data
end

function M.write_file(path, content)
  local fd = assert(vim.uv.fs_open(path, "w", 438))
  assert(vim.uv.fs_write(fd, content, 0))
  assert(vim.uv.fs_close(fd))
end

function M.sort_strings(tbl)
  table.sort(tbl, function(a, b)
    return a:lower() < b:lower()
  end)
  return tbl
end

return M
