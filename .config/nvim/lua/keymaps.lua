-- lua/keymaps.lua

-- Clear search highlights
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Split navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Disable s to avoid collision with mini surround
vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')

-- TmuxNavigator insert-mode mappings
for _, map in ipairs {
  { '<C-h>', '<Cmd>TmuxNavigateLeft<CR>' },
  { '<C-j>', '<Cmd>TmuxNavigateDown<CR>' },
  { '<C-k>', '<Cmd>TmuxNavigateUp<CR>' },
  { '<C-l>', '<Cmd>TmuxNavigateRight<CR>' },
} do
  vim.keymap.set('i', map[1], map[2], { silent = true })
end

-- Replace operator: use R to [R]eplace with buffer content
local function replace_op(type)
  local s = vim.api.nvim_buf_get_mark(0, '[')
  local e = vim.api.nvim_buf_get_mark(0, ']')
  local reg = vim.fn.getreg '"'
  local lines = vim.split(reg, '\n', { plain = true })
  -- Remove trailing empty line from linewise yank
  if #lines > 1 and lines[#lines] == '' then table.remove(lines) end
  if type == 'line' then
    vim.api.nvim_buf_set_lines(0, s[1] - 1, e[1], false, lines)
  else
    vim.api.nvim_buf_set_text(0, s[1] - 1, s[2], e[1] - 1, e[2] + 1, lines)
  end
end

REPLACE_KEY = 'R'
_G._replace_op = replace_op

vim.keymap.set('n', REPLACE_KEY, function()
  vim.o.operatorfunc = 'v:lua._replace_op'
  return 'g@'
end, { expr = true, desc = 'Substitude with register' })

vim.keymap.set('n', REPLACE_KEY .. REPLACE_KEY, function()
  vim.o.operatorfunc = 'v:lua._replace_op'
  return 'g@_'
end, { expr = true, desc = 'Substitude line with register' })
