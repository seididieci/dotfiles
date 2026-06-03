return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")

    ts.install({
      "lua",
      "rust",
      "javascript",
      "typescript",
      "c_sharp",
    })

    ts.update()

    local function start_tree_sitter(args)
      -- install specific parser
      local ft = args.match
      local lang = vim.treesitter.language.get_lang(ft)
      local excluded = { "netrw", "fugitive" }

      if excluded[lang] then
        return
      end

      if not vim.list_contains(ts.get_available(), lang) then
        return
      else
        ts.install(lang):await(function()
          -- can start a specific treesitter on a specific buffer also
          -- vim.treesitter.start(0, "c")
          vim.treesitter.start()
          -- folds, provided by Neovim
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldmethod = "expr"
          -- indentation, provided by nvim-treesitter
          vim.bo.indentexpr = "vh:lua.require'nvim-treesitter'.indentexpr()"
          vim.wo.foldlevel = 99
        end)
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterAutoinstallPlugin", {
        clear = true,
      }),
      callback = start_tree_sitter,
    })
  end,
}
