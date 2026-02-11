-- ~/.config/nvim/copy-mode.lua

-- === Chrome ===
vim.opt.termguicolors = true
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
vim.opt.signcolumn = "no"
vim.opt.fillchars = { eob = " " }
vim.opt.laststatus = 0
vim.opt.cmdheight = 0
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.showcmd = false
vim.opt.shortmess:append("I")
vim.opt.swapfile = false
vim.opt.virtualedit = "onemore"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- === Hide cursor until ready ===
vim.api.nvim_set_hl(0, "HiddenCursor", { blend = 100, nocombine = true })
vim.opt.guicursor = "a:HiddenCursor"

-- === Curtain: opaque floating window covering everything until content is ready ===
local curtain_buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_set_hl(0, "CurtainBg", { bg = "NONE", ctermbg = "NONE" })
local curtain_win = vim.api.nvim_open_win(curtain_buf, false, {
	relative = "editor",
	row = 0,
	col = 0,
	width = vim.o.columns,
	height = vim.o.lines,
	style = "minimal",
	focusable = false,
	zindex = 50,
})
vim.api.nvim_set_option_value("winhighlight", "Normal:CurtainBg,NormalFloat:CurtainBg", { win = curtain_win })

-- === Keymaps ===
local function quit()
	vim.cmd("qa!")
end
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
	group = vim.api.nvim_create_augroup("highlight-on-yank", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 5000 })
	end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		local text = table.concat(vim.v.event.regcontents, "\n")
		vim.fn.jobstart({ "wl-copy", "--", text }, { detach = true })
		vim.fn.jobstart({ "tmux", "set-buffer", "--", text }, { detach = true })
		vim.defer_fn(quit, 10)
	end,
})

-- === Load content ===
local file = vim.env.COPY_FILE
local history_size = tonumber(vim.env.HISTORY_SIZE) or 0
local target_line = history_size + (tonumber(vim.env.CURSOR_Y) or 1) + 1
local target_col = tonumber(vim.env.CURSOR_X) or 0

local f = io.open(file, "r")
local raw = f:read("*a"):gsub("\n+$", "")
f:close()
local _, total = raw:gsub("\n", "")

local buf = vim.api.nvim_create_buf(false, true)
local chan = vim.api.nvim_open_term(buf, {})
vim.api.nvim_chan_send(chan, raw)
vim.api.nvim_set_current_buf(buf)

-- === Wait for terminal to finish, then reveal ===
vim.api.nvim_buf_attach(buf, false, {
	on_lines = function()
		if vim.api.nvim_buf_line_count(buf) >= total then
			vim.schedule(function()
				vim.bo[buf].modifiable = false
				vim.api.nvim_win_set_cursor(0, { target_line, target_col })
				vim.fn.winrestview({
					topline = history_size + 1,
					lnum = target_line,
					col = target_col,
				})
				-- Remove curtain and reveal cursor
				if vim.api.nvim_win_is_valid(curtain_win) then
					vim.api.nvim_win_close(curtain_win, true)
				end

				vim.cmd("hi Normal ctermbg=NONE | hi CursorLine ctermbg=6 ctermfg=0 cterm=NONE ")
				vim.opt.cursorline = true
				vim.api.nvim_buf_delete(curtain_buf, { force = true })
				vim.opt.guicursor = {
					"n-v-c:block-Cursor",
					"i-ci-ve:ver25",
					"r-cr-o:hor20",
					"a:blinkon0",
				}
				vim.cmd("redraw!")
			end)
			return true
		end
	end,
})
