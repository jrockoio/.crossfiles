-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


vim.g.mapleader = " "

local plugins = {}

if vim.env.COPILOT == '1' then
  table.insert(plugins, 'github/copilot.vim')
end

table.insert(plugins, {
  -- Configurations for Nvim LSP
  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'williamboman/nvim-lsp-installer',

  -- lua config
  'folke/neodev.nvim',

  -- lsp status
  { 'j-hui/fidget.nvim', opts = {} },

  -- null-ls
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = "nvim-lua/plenary.nvim",
  },
  'jose-elias-alvarez/typescript.nvim',

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate'
  },

  -- completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Autocompletion
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      -- Snippets
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
    },
  },

  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  -- movement
  'takac/vim-hardtime',
  {
    'jinh0/eyeliner.nvim',
    config = function()
      require 'eyeliner'.setup {
        highlight_on_key = true, -- show highlights only after keypress
        dim = true
      }
    end
  },
  {
    'ThePrimeagen/harpoon',
    dependencies = 'nvim-lua/plenary.nvim',
  },

  -- lint
  'mfussenegger/nvim-lint',

  --caddyfile
  'isobit/vim-caddyfile',

  -- find/replace
  { 'nvim-pack/nvim-spectre',
    dependencies = 'nvim-lua/plenary.nvim',
  },

  --grepper
  'mhinz/vim-grepper',

  -- fzf
  { 'ibhagwan/fzf-lua',
    dependencies = { 'kyazdani42/nvim-web-devicons' } -- optional for icon support
  },

  -- debugging
  'mfussenegger/nvim-dap',
  'leoluz/nvim-dap-go',

  -- lf
  'VebbNix/lf-vim',
  'ptzz/lf.vim',
  'voldikss/vim-floaterm',

  -- git
  'airblade/vim-gitgutter',
  -- open in github
  {
    'ruifm/gitlinker.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
  },

  { 'akinsho/git-conflict.nvim', version = "*", config = true},

  --editorconfig
  'editorconfig/editorconfig-vim',

  -- auto-commenting
  'numToStr/Comment.nvim',
  'JoosepAlviste/nvim-ts-context-commentstring',

  -- surround
  'kylechui/nvim-surround',
  -- auto close brackets
  'rstacruz/vim-closer',
  -- auto end functions
  'tpope/vim-endwise',
  -- auto close html tags
  'windwp/nvim-ts-autotag',


  -- go
  'ray-x/go.nvim',
  'ray-x/guihua.lua', -- recommended if need floating window support

  -- java
  'mfussenegger/nvim-jdtls',

  -- nvim-test
   "klen/nvim-test",

  -- lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons', opt = true }
  },

  { 'f-person/git-blame.nvim',
    dependencies = { 'f-person/lua-timeago' }
  },

  -- tf syntax
  'hashivim/vim-terraform',
  -- just syntax
  'NoahTheDuke/vim-just',

  -- Color scheme
  'dikiaap/minimalist',
  'morhetz/gruvbox',
  'folke/tokyonight.nvim',

})

require('lazy').setup(plugins)
