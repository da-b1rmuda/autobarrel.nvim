local config = require("autobarrel.config")
local barrel = require("autobarrel.barrel")

local M = {}

function M.setup()
  if not config.options.auto_update then
    return
  end

  vim.api.nvim_create_augroup("Autobarrel", { clear = true })

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = "Autobarrel",
    pattern = config.options.auto_update_patterns,
    callback = function(args)
      barrel.update_from_file(args.file)
    end,
    desc = "Auto update nearest parent barrel on file save",
  })
end

return M
