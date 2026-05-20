return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	configure = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "lua", "rust", "javascript", "typescript" },
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		})
	end,
}
