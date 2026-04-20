local barrel = require("autobarrel.barrel")
local util = require("autobarrel.util")

local M = {}

local function resolve_dir(arg)
  if arg and arg ~= "" then
    return util.normalize(arg)
  end

  local current = vim.api.nvim_buf_get_name(0)
  if current == "" then
    return vim.fn.getcwd()
  end

  if util.is_dir(current) then
    return current
  end

  return util.dirname(current)
end

function M.setup()
  vim.api.nvim_create_user_command("BarrelCreate", function(opts)
    local dir = resolve_dir(opts.args)
    barrel.create(dir)
  end, {
    nargs = "?",
    complete = "dir",
    desc = "Create barrel file in directory",
  })

  vim.api.nvim_create_user_command("BarrelUpdate", function(opts)
    local dir = resolve_dir(opts.args)
    barrel.update(dir)
  end, {
    nargs = "?",
    complete = "dir",
    desc = "Update barrel file in directory",
  })
end

return M
