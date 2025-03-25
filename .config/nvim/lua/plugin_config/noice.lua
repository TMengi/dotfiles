local keymap = vim.keymap

require('noice').setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- TODO: Check out configuration options
  presets = {},
})

local silent_noremap = { silent = true, noremap = true }
keymap.set('n', '<leader>na', ':NoiceAll<cr>', silent_noremap)
keymap.set('n', '<leader>np', ':NoicePick<cr>', silent_noremap)
