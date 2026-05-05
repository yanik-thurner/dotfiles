-- lua/plugins/navigation.lua

---@module 'lazy'
---@type LazySpec
return {
  {
    'jiaoshijie/undotree',
    opts = {},
    keys = {
      { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>", desc = 'Open [U]ndo tree' },
    },
  },

  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>tt', '<cmd>Neotree toggle<cr>', desc = 'Toggle Neo-tree' },
    },
    opts = {},
  },
  {
    'mrjones2014/smart-splits.nvim',
    opts = {},
    keys = {
      { '<C-Left>', function() require('smart-splits').resize_left() end, desc = 'Resize left' },
      { '<C-Down>', function() require('smart-splits').resize_down() end, desc = 'Resize down' },
      { '<C-Up>', function() require('smart-splits').resize_up() end, desc = 'Resize up' },
      { '<C-Right>', function() require('smart-splits').resize_right() end, desc = 'Resize right' },
    },
  },
}
