return {
	"github/copilot.vim",
	event = "InsertEnter",
	config = function()
		vim.g.copilot_no_tab_map = true
		--vim.g.copilot_assume_mapped = true
		vim.g.copilot_tab_fallback = ""
		vim.keymap.set("i", "<C-g>", function()
			return vim.fn["copilot#Accept"]("\\<S-Tab>")
		end, { expr = true, silent = true, replace_keycodes = false })
	end,
}
