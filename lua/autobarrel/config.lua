local M = {}

M.defaults = {
  barrel_name = "index.ts",

  extensions = { "ts", "tsx", "js", "jsx" },

  exclude_files = {
    "index.ts",
    "index.tsx",
    "index.js",
    "index.jsx",
  },

  exclude_patterns = {
    "%.test%.[jt]sx?$",
    "%.spec%.[jt]sx?$",
    "%.stories%.[jt]sx?$",
    "%.d%.ts$",
  },

  recursive = false,

  auto_update = true,

  auto_update_patterns = { "*.ts", "*.tsx", "*.js", "*.jsx" },

  update_only_nearest = true,

  notify = true,

  neo_tree = {
    enabled = true,
    create_mapping = "<leader>bc",
    update_mapping = "<leader>bu",
  },
}

M.options = vim.deepcopy(M.defaults)

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
end

return M
