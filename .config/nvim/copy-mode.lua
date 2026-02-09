-- ~/.config/nvim/copy-mode.lua

vim.cmd 'hi Normal ctermbg=NONE'

-- Use terminal colors to blend in
vim.opt.termguicolors = false

-- Hide all chrome
vim.opt.signcolumn = 'no'
vim.opt.fillchars = { eob = ' ' } -- Hide ~ on empty lines
vim.opt.laststatus = 0
vim.opt.cmdheight = 0
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.shortmess:append 'I'

local function quit() vim.cmd 'qa!' end

-- Block insert/replace modes
for _, key in ipairs { 'a', 'A', 'i', 'I', 'o', 'O', 'R', 'c', 'C', 's', 'S', 'd', 'D', 'x', 'X', 'r', 'p', 'P', 'u', 'U' } do
  vim.keymap.set('n', key, '<Nop>')
end

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    local text = table.concat(vim.v.event.regcontents, '\n')
    vim.fn.jobstart({ 'wl-copy', '--', text }, { detach = true })
    vim.fn.jobstart({ 'tmux', 'set-buffer', '--', text }, { detach = true })
    vim.defer_fn(quit, 10)
  end,
})

-- Buffer settings
vim.opt.swapfile = false
vim.opt.virtualedit = 'onemore'
vim.opt.wrap = false

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Exit keys
vim.keymap.set('n', 'q', quit)
vim.keymap.set('n', '<Esc>', quit)
vim.keymap.set('n', '<CR>', quit)
vim.keymap.set('n', '<Space>', quit)

local function exit_pane(dir)
  return function()
    vim.fn.jobstart('tmux select-pane -' .. dir, { detach = true })
    quit()
  end
end

vim.keymap.set('n', '<C-h>', exit_pane 'L', { silent = true })
vim.keymap.set('n', '<C-j>', exit_pane 'D', { silent = true })
vim.keymap.set('n', '<C-k>', exit_pane 'U', { silent = true })
vim.keymap.set('n', '<C-l>', exit_pane 'R', { silent = true })

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.bo[0].buftype = 'nofile'
    vim.opt.shortmess:append 'I'

    local f = io.open(vim.env.COPY_FILE, 'r')
    local raw = f:read('*a'):gsub('\n$', '')
    f:close()

    local expected = 1
    for _ in raw:gmatch '\n' do
      expected = expected + 1
    end

    local buf = vim.api.nvim_create_buf(false, true)
    local chan = vim.api.nvim_open_term(buf, {})
    vim.api.nvim_chan_send(chan, raw)

    local row = tonumber(vim.env.COPY_LINE) or 1
    local col = tonumber(vim.env.COPY_COL) or 0

    local timer = vim.uv.new_timer()
    timer:start(
      0,
      2,
      vim.schedule_wrap(function()
        if vim.api.nvim_buf_line_count(buf) < expected then return end
        timer:stop()
        timer:close()

        vim.api.nvim_win_set_buf(0, buf)
        vim.bo[buf].modifiable = false
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
        vim.api.nvim_win_set_cursor(0, { row, col })
        vim.cmd 'redraw!'
        if col > 0 then vim.api.nvim_feedkeys(col .. '|', 'nx', false) end
      end)
    )
  end,
})
