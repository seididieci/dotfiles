local lsp_zero = require("lsp-zero")

local lsp_attach = function(_, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>vws", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set("n", "<leader>vd", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set("n", "<leader>vca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("v", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>vrr", function()
		require("telescope.builtin").lsp_references({})
	end, opts)
	vim.keymap.set("n", "<leader>vrn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
end

lsp_zero.extend_lspconfig({
	sign_text = {
		error = "✘",
		warn = "▲",
		hint = "⚑",
		info = "»",
	},
	lsp_attach = lsp_attach,
	float_border = "rounded",
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

require("mason").setup({})
require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
		csharp_ls = function()
			require("lspconfig").csharp_ls.setup({
				handlers = {
					["textDocument/definition"] = require("csharpls_extended").handler,
					["textDocument/typeDefinition"] = require("csharpls_extended").handler,
				},
			})
		end,
		vuels = function()
			lsp_zero.configure("vuels", {
				settings = {
					vetur = {
						experimental = {
							templateInterpolationService = true,
						},
					},
				},
			})
		end,
		lua_ls = function()
			lsp_zero.configure("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = { vim.env.VIMRUNTIME },
						},
					},
				},
			})
		end,
		yamlls = function()
			lsp_zero.configure("yamlls", {
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = true
					lsp_attach(client, bufnr)
				end,
				settings = {
					yaml = {
						keyOrdering = false,
					},
				},
			})
		end,
	},
})

local cmp = require("cmp")
local cmp_action = lsp_zero.cmp_action()
local luasnip = require("luasnip")

local cmp_select = { behaviour = cmp.SelectBehavior.Select }
local cmp_mappings = cmp.mapping.preset.insert({
	["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
	["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
	["<Enter>"] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),

	-- scroll up and down the documentation window
	["<C-u>"] = cmp.mapping.scroll_docs(-4),
	["<C-d>"] = cmp.mapping.scroll_docs(4),

	["<Tab>"] = cmp_action.luasnip_jump_forward(),
	["<S-Tab>"] = cmp_action.luasnip_jump_backward(),
})

cmp.setup({
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp_mappings,
	view = {
		entries = { name = "custom", selection_order = "near_cursor" },
	},

	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			if vim.tbl_contains({ "path" }, entry.source.name) then
				local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
				if icon then
					vim_item.kind = icon
					vim_item.kind_hl_group = hl_group
					return vim_item
				end
			end
			local kind = require("lspkind").cmp_format({ with_text = true })(entry, vim_item)
			local strings = vim.split(kind.kind, "%s", { trimempty = true })
			kind.kind = " " .. (strings[1] or "") .. " "
			kind.menu = "    (" .. (strings[2] or "") .. ")"
			return kind
		end,
	},
})

lsp_zero.setup()

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
})

vim.api.nvim_set_keymap("n", "<leader>x", "", {
	noremap = true,
	callback = function()
		for _, client in ipairs(vim.lsp.get_clients()) do
			require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
		end
	end,
})
