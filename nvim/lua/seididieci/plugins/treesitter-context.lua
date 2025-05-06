return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("treesitter-context").setup({
      enable = true,
      max_lines = 4,
      trim_scope = "outer",
      min_window_height = 0,
      multiline_threshold = 8,
    })
  end,
}
