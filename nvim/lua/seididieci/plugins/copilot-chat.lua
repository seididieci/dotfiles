return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
			trusted_tools = nil, -- Require approval for all tool calls
			window = {
				layout = "float", -- 'vertical', 'horizontal', 'float'
				width = 80, -- Fixed width in columns
				height = 20, -- Fixed height in rows
				border = "rounded", -- 'single', 'double', 'rounded', 'solid'
			},
			auto_insert_mode = true, -- Enter insert mode when opening
		},
		config = function(_, opts)
			require("CopilotChat").setup(opts)
			vim.keymap.set("n", "<leader>cs", vim.cmd.CopilotChatToggle, { desc = "Toggle Copilot Chat" })
		end,
	},
}
