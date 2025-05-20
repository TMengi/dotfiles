local diagnostic = vim.diagnostic
local keymap = vim.keymap
local lsp = vim.lsp

-- Mason core is automatically setup by lspconfig
require('mason-lspconfig').setup({
  ensure_installed = {
    'buf_ls',
    'clangd',
    'jsonls',
    'lua_ls',
    'markdown_oxide',
    'pyright@1.1.259',
    'ruff',
    'rust_analyzer',
    'yamlls',
  },
})

local on_attach_global = function(_, _)
  keymap.set('n', '<leader>rn', lsp.buf.rename)
  keymap.set('n', '<leader>ca', lsp.buf.code_action)
  keymap.set('n', 'K', lsp.buf.hover)
  keymap.set('n', 'gd', lsp.buf.definition)
  keymap.set('n', 'gD', lsp.buf.declaration)
  keymap.set('n', 'gi', lsp.buf.implementation)
  keymap.set('n', 'gr', require('telescope.builtin').lsp_references)
  keymap.set('n', ']g', diagnostic.goto_next)
  keymap.set('n', '[g', diagnostic.goto_prev)
  keymap.set('i', '<c-k>', lsp.buf.signature_help)
end

-- Include completion capabilities in various LSPs
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
-- The available configurations live in
-- ~/.local/share/nvim/lazy/nvim-lspconfig/lua/lspconfig/server_configurations
-- TODO: Figure out how to pass on_attach and capabilities as an extendable
-- table to all configs
lspconfig.lua_ls.setup({
  on_attach = on_attach_global,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = {
          'vim', -- Tells the LSP that the vim API is in the global namespace
        },
      },
    },
  },
})
lspconfig.pyright.setup({ on_attach = on_attach_global, capabilities = capabilities })
lspconfig.rust_analyzer.setup({
  on_attach = on_attach_global,
  capabilities = capabilities,
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
})
lspconfig.buf_ls.setup({ on_attach = on_attach_global, capabilities = capabilities })
lspconfig.yamlls.setup({ on_attach = on_attach_global, capabilities = capabilities })
lspconfig.jsonls.setup({ on_attach = on_attach_global, capabilities = capabilities })
lspconfig.markdown_oxide.setup({ on_attach = on_attach_global, capabilities = capabilities })
lspconfig.clangd.setup({
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  on_attach = function()
    on_attach_global()
    keymap.set('n', '<leader>oo', ':ClangdSwitchSourceHeader<cr>', { silent = true })
  end,
  capabilities = capabilities,
})
