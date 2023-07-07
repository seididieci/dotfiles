-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'rstacruz/vim-closer'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use({
    'rose-pine/neovim',
    as = 'rose-pine',
    -- config = function()
    --   vim.cmd('colorscheme rose-pine')
    -- end
  })

  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
  use('nvim-treesitter/nvim-treesitter-context')
  use('ThePrimeagen/harpoon')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')

  use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lua' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'rafamadriz/friendly-snippets' },
    }
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use('lewis6991/gitsigns.nvim')

  use({
    "vuki656/package-info.nvim",
    requires = "MunifTanjim/nui.nvim",
  })

  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = "nvim-lua/plenary.nvim",
  })

  use 'ThePrimeagen/vim-be-good'

  --- Debugging...
  --use('puremourning/vimspector')
  use('mfussenegger/nvim-dap')
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }


  -- Some usless cool stuff
  use ('mattn/calendar-vim')
end)
