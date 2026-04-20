local barrel = require("autobarrel.barrel")
local util = require("autobarrel.util")

local M = {}

local function refresh_neotree(state)
  vim.schedule(function()
    local ok, manager = pcall(require, "neo-tree.sources.manager")
    if not ok then
      return
    end

    pcall(manager.refresh, state and state.name or "filesystem")
  end)
end

local function get_dir_from_node(state)
  local node = state.tree:get_node()
  if not node then
    util.notify("No neo-tree node selected", vim.log.levels.ERROR)
    return nil
  end

  local path = node.path
  if not path then
    util.notify("Selected neo-tree node has no path", vim.log.levels.ERROR)
    return nil
  end

  if node.type == "directory" then
    return path
  end

  return util.dirname(path)
end

function M.create_from_state(state)
  local dir = get_dir_from_node(state)
  if not dir then
    return
  end

  local ok = barrel.create(dir)
  if ok then
    refresh_neotree(state)
  end
end

function M.update_from_state(state)
  local dir = get_dir_from_node(state)
  if not dir then
    return
  end

  local ok = barrel.update(dir)
  if ok then
    refresh_neotree(state)
  end
end

return M
