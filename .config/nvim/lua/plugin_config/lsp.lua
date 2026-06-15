--[[ LSP server configuration

Steps to configure a new server:
  - Add to the mason-lspconfig setup below
  - Enable wit hthe vim.lsp API
  - Configure options in the LspAttach command

--]]
local api = vim.api
local diagnostic = vim.diagnostic
local keymap = vim.keymap
local lsp = vim.lsp

-- Mason core is automatically setup by lspconfig
require('mason-lspconfig').setup({
  ensure_installed = {
    'ansiblels',
    'clangd',
    'jsonls',
    'lua_ls@3.16.4', -- Temporary for https://github.com/folke/lazydev.nvim/issues/136
    'markdown_oxide',
    'pyrefly',
    'ruff',
    'rust_analyzer',
    'stylua',
    'yamlls',
  },
})

-- The available configurations live in
-- ~/.local/share/nvim/lazy/nvim-lspconfig/lsp
lsp.enable('ansiblels')
lsp.enable('bash-language-server')
lsp.enable('clangd')
lsp.enable('jsonls')
lsp.enable('lua_ls')
lsp.enable('markdown_oxide')
lsp.enable('pyrefly')
lsp.enable('ruff')
-- This is managed separately by rustaceanvim
lsp.enable('rust_analyzer', false)
lsp.enable('yamlls')

-- Keymaps and settings to configure for every language server
local on_attach_global = function(_, _)
  keymap.set('n', '<leader>rn', lsp.buf.rename)
  keymap.set('n', '<leader>ca', lsp.buf.code_action)
  keymap.set('n', 'K', lsp.buf.hover)
  keymap.set('n', 'gd', lsp.buf.definition)
  keymap.set('n', 'gD', lsp.buf.declaration)
  keymap.set('n', 'gi', lsp.buf.implementation)
  keymap.set('n', 'gr', require('telescope.builtin').lsp_references)
  keymap.set('n', ']g', function()
    diagnostic.jump({ count = 1, float = true })
  end)
  keymap.set('n', '[g', function()
    diagnostic.jump({ count = -1, float = true })
  end)
  keymap.set('i', '<c-k>', lsp.buf.signature_help)
end

api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    on_attach_global()

    if client.name == 'clangd' then
      keymap.set('n', '<leader>oo', ':LspClangdSwitchSourceHeader<cr>', { silent = true })
    end
  end,
})

local print_lsp_clients = function()
  print(vim.inspect(vim.tbl_map(function(client)
    return client.name
  end, vim.lsp.get_clients())))
end
api.nvim_create_user_command('LspList', print_lsp_clients, {})
