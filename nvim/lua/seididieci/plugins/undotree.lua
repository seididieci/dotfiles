return {
	"mbbill/undotree",
	config = function()
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		vim.g.undotree_SetFocusWhenToggle = 1
		vim.g.undotree_WindowLayout = 2
		vim.g.undotree_ShortIndicators = 1
		vim.g.undotree_SplitWidth = 35
		vim.g.undotree_DiffpanelHeight = 10
	end,
}
