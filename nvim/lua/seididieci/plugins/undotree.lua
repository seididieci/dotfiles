local function get_undo_dir()
  local undodir = vim.fn.expand('~/.undodir')
  if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, 'p', 448)
  end

  -- Get current file path
  local path = vim.fn.expand('%:p')
  if path == '' then
    return undodir
  end

  -- Use hash for long paths to avoid "Cannot open undo file for writing" errors
  local safe_path = string.gsub(path, '/', '%%')
  if string.len(safe_path) > 250 then
    -- Use a simple hash function for long paths
    local hash = 0
    for i = 1, #path do
      hash = (hash * 31 + string.byte(path, i)) % 1000000007
    end
    return undodir .. '/' .. hash
  end

  return undodir .. '/' .. safe_path
end

return {
  "mbbill/undotree",

  config = function()
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_ShortIndicators = 1
    vim.g.undotree_SplitWidth = 35
    vim.g.undotree_DiffpanelHeight = 10

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePre" }, {
      --group = ThePrimeagenGroup, -- Fixed variable name capitalization
      pattern = "*",
      callback = function()
        vim.opt_local.undodir = get_undo_dir()
      end,
    })
  end
}
