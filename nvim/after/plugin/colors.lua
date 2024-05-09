function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

--ColorMyPencils()
require("cyberdream").setup({
	transparent = false,
	italic_comments = true,
	hide_fillchars = true,
	borderless_telescope = false,
	terminal_colors = true,
})
vim.cmd("colorscheme cyberdream") -- set the colorscheme
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
