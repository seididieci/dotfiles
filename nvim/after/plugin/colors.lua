function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

require("cyberdream").setup({
	transparent = false,
	italic_comments = true,
	hide_fillchars = true,
	borderless_pickers = false,
	terminal_colors = true,
})

ColorMyPencils("moonfly")
