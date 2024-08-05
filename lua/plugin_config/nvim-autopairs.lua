local autopairs = require('nvim-autopairs')
local cond = require('nvim-autopairs.conds')
local Rule = require('nvim-autopairs.rule')

autopairs.setup({
  event = "InsertEnter",
  config = true,
  enable_check_bracket_line = true,
})

autopairs.add_rules({
  Rule('<', '>', 'rust')
    -- Don't add pair after a space, which allows for typing normal comparison
    -- operators
    :with_pair(
      cond.not_before_regex(' ')
    )
    -- Move cursor right when completing the pair
    :with_move(cond.done())
    -- Don't split pair onto multiple lines with carriage return
    :with_cr(cond.none())
})
