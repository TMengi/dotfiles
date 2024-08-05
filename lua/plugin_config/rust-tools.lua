local diagnostic = vim.diagnostic
local keymap = vim.keymap
local lsp = vim.lsp

-- ### DAP configuration ###
local dap = require('dap')
local dapui = require('dapui')
dapui.setup()

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

keymap.set('n', '<leader>dt', ':DapToggleBreakpoint<cr>')
keymap.set('n', '<leader>dx', ':DapTerminate<cr>')
keymap.set('n', '<leader>do', ':DapStepOver<cr>')

-- Use LLDB path installed through Mason
local mason_registry = require('mason-registry')
local codelldb = mason_registry.get_package('codelldb')
local extension_path = codelldb:get_install_path() .. '/extension/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

-- ### Rust Tools configuration ###
local rt = require('rust-tools')
local rt_dap = require('rust-tools.dap')

local capabilities = require('cmp_nvim_lsp').default_capabilities()
rt.setup({
  dap = {
    adapter = rt_dap.get_codelldb_adapter(codelldb_path, liblldb_path),
  },
  server = {
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      keymap.set('n', '<leader>rn', lsp.buf.rename)
      keymap.set('n', '<leader>ca', rt.code_action_group.code_action_group, { buffer = bufnr })
      keymap.set('n', '<leader>k', rt.hover_actions.hover_actions, { buffer = bufnr })
      keymap.set('n', 'K', lsp.buf.hover)
      keymap.set('n', 'gd', lsp.buf.definition)
      keymap.set('n', 'gD', lsp.buf.declaration)
      keymap.set('n', 'gi', lsp.buf.implementation)
      keymap.set('n', 'gr', require('telescope.builtin').lsp_references)
      keymap.set('n', ']g', diagnostic.goto_next)
      keymap.set('n', '[g', diagnostic.goto_prev)
      keymap.set('i', '<c-k>', lsp.buf.signature_help)
    end,
  },
  tools = {
    hover_actions = {
      auto_focus = true,
    },
  },
})
