-- Bootstraps the plugin manager and declares plugins to load

-- Enforce lazy.nvim installation
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

-- Plugins to include
require('lazy').setup({
  -- Colorschemes,
  'catppuccin/nvim',

  -- Editor niceties
  'windwp/nvim-autopairs', -- Automatically add surround mark pairs
  'kylechui/nvim-surround', -- Surround mark manager
  -- Quick buffer navigation
  {
    url = 'https://codeberg.org/andyg/leap.nvim',
  },
  'Yggdroot/indentLine', -- Nice indentation formatting
  'numToStr/comment.nvim', -- Quick commenter
  'nvim-tree/nvim-tree.lua', -- File tree
  'mhartington/formatter.nvim',

  -- Git integrations
  'airblade/vim-gitgutter', -- Modifiation marks in the numcol
  'f-person/git-blame.nvim', -- Blame
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },

  -- Language servers, completions, syntax highlighting
  {
    'mason-org/mason-lspconfig.nvim', -- Interface to lspconfig
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'neovim/nvim-lspconfig', -- Quickstarts for lspconfig
    },
  },
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
  'nvim-treesitter/nvim-treesitter', -- Concrete syntax tree, highlighting, etc.

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- Icons for status line and file tree
    },
  },

  -- Telescope picker
  {
    'nvim-telescope/telescope.nvim',
    tag = 'v0.1.9',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },

  -- Notification and log handler
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },

  -- Rust specific
  {
    'simrat39/rust-tools.nvim',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
      'rcarriga/nvim-dap-ui',
    },
  },

  -- Lua specific
  'folke/lazydev.nvim',
  {
    -- optional cmp completion source for require statements and module
    -- annotations
    'hrsh7th/nvim-cmp',
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = 'lazydev',
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },

  -- My plugins
  dir = 'my_plugins/qftools',
})
