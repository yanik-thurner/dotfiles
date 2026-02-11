-- ~/.config/nvim/copy-mode.lua
--
vim.cmd("hi Normal ctermbg=NONE")
vim.opt.cursorline = true
vim.cmd("hi CursorLine ctermbg=yellow ctermfg=0 cterm=NONE")

-- Use terminal colors to blend in
vim.opt.termguicolors = false

-- Hide all chrome
vim.opt.signcolumn = "no"
vim.opt.fillchars = { eob = " " } -- Hide ~ on empty lines
vim.opt.laststatus = 0
vim.opt.cmdheight = 0
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.shortmess:append("I")

local function quit()
	vim.cmd("qa!")
end

-- Block insert/replace modes
for _, key in ipairs({
	"a",
	"A",
	"i",
	"I",
	"o",
	"O",
	"R",
	"c",
	"C",
	"s",
	"S",
	"d",
	"D",
	"x",
	"X",
	"r",
	"p",
	"P",
	"u",
	"U",
	"Q",
}) do
	vim.keymap.set("n", key, "<Nop>")
end

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Pipe yanked text into clipboard(s)",
	callback = function()
		local text = table.concat(vim.v.event.regcontents, "\n")
		vim.fn.jobstart({ "wl-copy", "--", text }, { detach = true })
		vim.fn.jobstart({ "tmux", "set-buffer", "--", text }, { detach = true })
		vim.defer_fn(quit, 10)
	end,
})

-- Buffer settings
vim.opt.swapfile = false
vim.opt.virtualedit = "onemore"

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Exit keys
vim.keymap.set("n", "q", quit)
vim.keymap.set("n", "<Esc>", quit)
vim.keymap.set("n", "<CR>", quit)
vim.keymap.set("n", "<Space>", quit)

local function exit_pane(dir)
	return function()
		vim.fn.jobstart("tmux select-pane -" .. dir, { detach = true })
		quit()
	end
end

vim.keymap.set("n", "<C-h>", exit_pane("L"), { silent = true })
vim.keymap.set("n", "<C-j>", exit_pane("D"), { silent = true })
vim.keymap.set("n", "<C-k>", exit_pane("U"), { silent = true })
vim.keymap.set("n", "<C-l>", exit_pane("R"), { silent = true })

local function dbg(msg)
	local f = io.open("/tmp/copy-mode-debug.txt", "a")
	f:write(tostring(msg) .. "\n")
	f:close()
end

local file = vim.env.COPY_FILE
local history_size = tonumber(vim.env.HISTORY_SIZE) or 0
local target_line = history_size + (tonumber(vim.env.CURSOR_Y) or 1) + 1
local target_col = tonumber(vim.env.CURSOR_X) or 0
dbg("target_line: ", target_line, " target_col: ", target_col)

local f = io.open(file, "r")
local raw = f:read("*a"):gsub("\n+$", "")
local _, total = raw:gsub("\n", "")
f:close()

local buf = vim.api.nvim_create_buf(false, true)
local chan = vim.api.nvim_open_term(buf, {})
vim.api.nvim_chan_send(chan, raw)

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		vim.api.nvim_buf_attach(buf, false, {
			on_lines = function()
				if vim.api.nvim_buf_line_count(buf) >= total then
					vim.schedule(function()
						vim.api.nvim_win_set_buf(0, buf)
						vim.bo[buf].modifiable = false
						vim.api.nvim_win_set_cursor(0, { target_line, target_col })
						vim.fn.winrestview({
							topline = history_size + 1,
							lnum = target_line,
							col = target_col,
						})
						vim.cmd("redraw!")
					end)
					return true
				end
			end,
		})
	end,
})
