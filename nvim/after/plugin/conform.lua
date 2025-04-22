local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt", lsp_format = "fallback" },
		--javascript = { "prettierd", "prettier", stop_after_first = true },
		vue = { "prettierd", "volar", stop_after_first = true },
		typescript = { lsp_format = "true" },
	},
})
