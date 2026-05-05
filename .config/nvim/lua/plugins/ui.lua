-- lua/plugins/ui.lua

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

---@module 'lazy'
---@type LazySpec
return {
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = { comments = { italic = false } },
      }
      vim.cmd.colorscheme 'tokyonight-night'

      vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#565f89' })
    end,
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      routes = { { view = 'cmdline', filter = { event = 'msg_showmode' } } },
    },
    keys = {
      {
        '<C-f>',
        function()
          if not require('noice.lsp').scroll(4) then return '<C-f>' end
        end,
        mode = { 'n', 'i', 's' },
        silent = true,
        expr = true,
      },
      {
        '<C-b>',
        function()
          if not require('noice.lsp').scroll(-4) then return '<C-b>' end
        end,
        mode = { 'n', 'i', 's' },
        silent = true,
        expr = true,
      },
      {
        '<C-d>',
        function()
          if not require('noice.lsp').scroll(2) then return '<C-d>' end
        end,
        mode = { 'n', 'i', 's' },
        silent = true,
        expr = true,
      },
      {
        '<C-u>',
        function()
          if not require('noice.lsp').scroll(-2) then return '<C-u>' end
        end,
        mode = { 'n', 'i', 's' },
        silent = true,
        expr = true,
      },
      {
        'q',
        function()
          if require('noice.lsp').scroll(0) then
            require('noice').cmd 'dismiss'
          else
            return 'q'
          end
        end,
        expr = true,
        desc = 'Dismiss noice hover or fallthrough',
      },
    },
  },

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = { signs = false },
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    ---@module 'which-key'
    ---@type wk.Opts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>d', group = '[D]ebug' },
        { '<leader>r', group = '[R]ust', mode = 'n' },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
      },
      triggers = {
        { '<auto>', mode = 'nixsotc' },
        { 's', mode = { 'n', 'v' } },
      },
    },
  },

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    ---@module 'ibl'
    ---@type ibl.config
    opts = {},
  },
}
