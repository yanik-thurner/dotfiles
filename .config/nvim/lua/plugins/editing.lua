-- lua/plugins/editing.lua

---@module 'lazy'
---@type LazySpec
return {

  {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    event = 'VeryLazy',
    opts = {},
  },

  { 'NMAC427/guess-indent.nvim', opts = {} },

  {
    'nvim-mini/mini.nvim',
    config = function()
      local ai = require 'mini.ai'

      local function ts_spec(captures)
        local spec = ai.gen_spec.treesitter(captures)
        return function(ai_type)
          local ok, parser = pcall(vim.treesitter.get_parser, 0)
          if ok and parser then parser:parse() end
          return spec(ai_type)
        end
      end

      ai.setup {
        n_lines = 500,
        custom_textobjects = {
          f = ts_spec { a = '@function.outer', i = '@function.inner' },
          c = ts_spec { a = '@class.outer', i = '@class.inner' },
        },
      }

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end

      require('mini.surround').setup()
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },
}
