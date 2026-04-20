local config = require("autobarrel.config")
local util = require("autobarrel.util")

local M = {}

local function matches_extension(filename)
  local opts = config.options
  for _, ext in ipairs(opts.extensions) do
    if filename:match("%." .. vim.pesc(ext) .. "$") then
      return true
    end
  end
  return false
end

local function is_excluded_file(filename)
  local opts = config.options

  if util.tbl_contains(opts.exclude_files, filename) then
    return true
  end

  for _, pattern in ipairs(opts.exclude_patterns) do
    if filename:match(pattern) then
      return true
    end
  end

  return false
end

function M.is_source_file(filename)
  return matches_extension(filename) and not is_excluded_file(filename)
end

function M.scandir(dir)
  local result = {}
  local handle = vim.uv.fs_scandir(dir)
  if not handle then
    return result
  end

  while true do
    local name, t = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end

    table.insert(result, {
      name = name,
      type = t,
      path = util.joinpath(dir, name),
    })
  end

  return result
end

function M.list_source_files(dir)
  local files = {}

  for _, entry in ipairs(M.scandir(dir)) do
    if entry.type == "file" and M.is_source_file(entry.name) then
      table.insert(files, entry)
    end
  end

  table.sort(files, function(a, b)
    return a.name:lower() < b.name:lower()
  end)

  return files
end

function M.barrel_path(dir)
  return util.joinpath(dir, config.options.barrel_name)
end

function M.has_barrel(dir)
  return util.is_file(M.barrel_path(dir))
end

function M.find_parent_barrels(start_path)
  local result = {}
  local current = start_path

  if util.is_file(current) then
    current = util.dirname(current)
  end

  current = util.normalize(current)

  while current do
    local barrel = M.barrel_path(current)
    if util.is_file(barrel) then
      table.insert(result, barrel)
    end

    local parent = util.dirname(current)
    if not parent or parent == current then
      break
    end
    current = parent
  end

  return result
end

function M.find_nearest_parent_barrel(start_path)
  local barrels = M.find_parent_barrels(start_path)
  return barrels[1]
end

return M
