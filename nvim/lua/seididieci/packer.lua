-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	use("rstacruz/vim-closer")
	use({ "kyazdani42/nvim-web-devicons" })

	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- Color Schemes
	use({ "rose-pine/neovim", as = "rose-pine" })
	use({ "bluz71/vim-moonfly-colors", as = "moonfly" })
	use({ "scottmckendry/cyberdream.nvim" })
	use({ "projekt0n/github-nvim-theme" })
	use({ "EdenEast/nightfox.nvim" })

	-- Treesitter
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use({
		"nvim-treesitter/nvim-treesitter-context",
		requires = {
			"nvim-treesitter/nvim-treesitter",
		},
	})

	use({ "ThePrimeagen/harpoon", branch = "harpoon2" })
	use("mbbill/undotree")
	use("tpope/vim-fugitive")
	use({
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})

	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "artemave/workspace-diagnostics.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "onsails/lspkind.nvim" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	})

	-- This is for the C# LSP Go to Defitinion on non-project files
	use({
		"Decodetalkers/csharpls-extended-lsp.nvim",
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
	})

	use("lewis6991/gitsigns.nvim")

	use({
		"vuki656/package-info.nvim",
		requires = "MunifTanjim/nui.nvim",
	})

	-- use({
	-- 	"jose-elias-alvarez/null-ls.nvim",
	-- 	requires = "nvim-lua/plenary.nvim",
	-- })

	use("ThePrimeagen/vim-be-good")

	--- Debugging...
	--use('puremourning/vimspector')
	use("mfussenegger/nvim-dap")
	use({
		"rcarriga/nvim-dap-ui",
		requires = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
	})

	-- Some useless cool stuff
	use("mattn/calendar-vim")

	use({
		"Exafunction/codeium.vim",
		requires = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
	})

	use("sindrets/diffview.nvim")
end)
