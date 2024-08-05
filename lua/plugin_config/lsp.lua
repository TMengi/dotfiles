local diagnostic = vim.diagnostic
local keymap = vim.keymap
local lsp = vim.lsp

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'pyright@1.1.259',
    'rust_analyzer',
    'clangd',
    'bufls',
    'yamlls',
    'jsonls',
    'remark_ls',
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
lspconfig.pyright.setup({
  capabilities = capabilities,
  on_attach = function(_, _)
    on_attach_global()
    -- keymap.set('n', '<leader>i', ':PyrightOrganizeImports<cr>')
    -- Custom isort configuration that works like Astranis linters
    local command = [[
      :!isort %
      --force-single-line-imports
      --force-sort-within-sections
      --force-alphabetical-sort-within-sections
      --use-parentheses
      -p astranis
      -p ops
      -p gnc_python
      -p network_sw
      -p sk
      -p sw
      --single-line-exclusions collections.abc
      --single-line-exclusions typing
      --single-line-exclusions typing_extensions
      --single-line-exclusions pants.core.goals.package
      --single-line-exclusions pants.core.goals.publish
      --single-line-exclusions pants.core.util_rules.external_tool
      --single-line-exclusions pants.engine.environment
      --single-line-exclusions pants.engine.fs
      --single-line-exclusions pants.engine.process
      --single-line-exclusions pants.engine.rules
    ]]
    command = command:gsub('\n', '') .. '<cr><cr>'
    keymap.set('n', '<leader>i', command, { silent = true })
  end,
})
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
lspconfig.bufls.setup({ on_attach = on_attach_global, capabilities = capabilities })
lspconfig.yamlls.setup({ on_attach = on_attach_global, capabilities = capabilities })
lspconfig.jsonls.setup({ on_attach = on_attach_global, capabilities = capabilities })
lspconfig.remark_ls.setup({ on_attach = on_attach_global, capabilities = capabilities })
lspconfig.clangd.setup({
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  on_attach = function()
    on_attach_global()
    keymap.set('n', '<leader>o', ':ClangdSwitchSourceHeader<cr>')
  end,
  capabilities = capabilities,
})
