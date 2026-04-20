local config = require("autobarrel.config")

local M = {}

function M.setup(opts)
  config.setup(opts)

  require("autobarrel.commands").setup()
  require("autobarrel.autocmd").setup()
end

function M.create(dir)
  return require("autobarrel.barrel").create(dir)
end

function M.update(dir)
  return require("autobarrel.barrel").update(dir)
end

return M
