-- Bootstraps the plugin manager

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Colorschemes,
  'ellisonleao/gruvbox.nvim',
  'catppuccin/nvim',

  'nvim-tree/nvim-tree.lua', -- File tree
  {
    'nvim-lualine/lualine.nvim', -- Status line
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- Icons for status line and file tree
    },
  },
  'nvim-treesitter/nvim-treesitter',
  {
    'nvim-telescope/telescope.nvim', -- Fuzzy find and other things
    tag = '0.1.4',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
  {
    'williamboman/mason.nvim', -- Language servers
    dependencies = {
      'williamboman/mason-lspconfig.nvim', -- Interface to lspconfig
      'neovim/nvim-lspconfig', -- Quickstarts for lspconfig
    },
  },
  'windwp/nvim-autopairs',
  'ggandor/leap.nvim', -- Quick buffer navigation
  'Yggdroot/indentLine', -- Nice indentation formatting
  'numToStr/comment.nvim', -- Quick commenter
  'airblade/vim-gitgutter',
  {
    'hrsh7th/nvim-cmp', -- Completions...
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', --
      'hrsh7th/cmp-buffer', -- From buffers
      'hrsh7th/cmp-path', -- From filetree
      'hrsh7th/cmp-cmdline', -- From command line
      'hrsh7th/cmp-vsnip', -- Snippet engine
      'hrsh7th/vim-vsnip', --
      'hrsh7th/cmp-nvim-lsp-signature-help', -- Function signature completion
    },
  },
  'mhartington/formatter.nvim',
  {
    'simrat39/rust-tools.nvim',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
      'rcarriga/nvim-dap-ui',
    },
  },
})
