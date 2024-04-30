-- packer bootstrap
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  if vim.env.COPILOT == '1' then
    use 'github/copilot.vim'
  end

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Configurations for Nvim LSP
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'williamboman/nvim-lsp-installer'

  -- lua config
  use 'folke/neodev.nvim'

  -- lsp status
  use { 'j-hui/fidget.nvim', opts = {} }

  -- null-ls
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = "nvim-lua/plenary.nvim",
  }
  use 'jose-elias-alvarez/typescript.nvim'

  -- treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    run = ':TSUpdate'
  }

  -- completion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      -- Autocompletion
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      -- Snippets
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
    },
  }

  -- markdown preview
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  -- movement
  use 'takac/vim-hardtime'
  use {
    'jinh0/eyeliner.nvim',
    config = function()
      require 'eyeliner'.setup {
        highlight_on_key = true, -- show highlights only after keypress
        dim = true
      }
    end
  }
  use {
    'ThePrimeagen/harpoon',
    requires = 'nvim-lua/plenary.nvim',
  }

  -- lint
  use 'mfussenegger/nvim-lint'

  --caddyfile
  use 'isobit/vim-caddyfile'

  -- find/replace
  use { 'nvim-pack/nvim-spectre',
    requires = 'nvim-lua/plenary.nvim',
  }

  --grepper
  use 'mhinz/vim-grepper'

  -- fzf
  use { 'ibhagwan/fzf-lua',
    requires = { 'kyazdani42/nvim-web-devicons' } -- optional for icon support
  }

  -- debugging
  use 'mfussenegger/nvim-dap'
  use 'leoluz/nvim-dap-go'

  -- lf
  use 'VebbNix/lf-vim'
  use 'ptzz/lf.vim'
  use 'voldikss/vim-floaterm'

  -- git
  use 'airblade/vim-gitgutter'
  -- open in github
  use {
    'ruifm/gitlinker.nvim',
    requires = 'nvim-lua/plenary.nvim',
  }
  use { 'akinsho/git-conflict.nvim', tag = "*", config = function()
    require('git-conflict').setup()
  end }

  --editorconfig
  use 'editorconfig/editorconfig-vim'

  -- auto-commenting
  use 'numToStr/Comment.nvim'
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  -- surround
  use 'kylechui/nvim-surround'
  -- auto close brackets
  use 'rstacruz/vim-closer'
  -- auto end functions
  use 'tpope/vim-endwise'
  -- auto close html tags
  use 'windwp/nvim-ts-autotag'


  -- go
  use 'ray-x/go.nvim'
  use 'ray-x/guihua.lua' -- recommended if need floating window support

  -- java
  use 'mfussenegger/nvim-jdtls'

  -- nvim-test
  use { "klen/nvim-test" }

  -- lualine
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use { 'f-person/git-blame.nvim',
    requires = { 'f-person/lua-timeago' }
  }

  -- tf syntax
  use 'hashivim/vim-terraform'
  -- just syntax
  use 'NoahTheDuke/vim-just'

  -- Color scheme
  use 'dikiaap/minimalist'
  use 'morhetz/gruvbox'
  use 'folke/tokyonight.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end
end)
