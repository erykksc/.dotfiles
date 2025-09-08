vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- visual
vim.g.have_nerd_font = true
vim.g.netrw_banner = 0
vim.g.netrw_preview = 1
vim.opt.inccommand = "split" -- Preview substitutions live, as you type!
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.scrolloff = 8 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.wrap = false -- Disable line wrapping
vim.opt.number = true -- show absolute number on cursor line
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "+1"
vim.o.winborder = "single" -- Set the floating window border (like lsp hover)
vim.opt.listchars = {
	space = "·",
	trail = "·",
	nbsp = "␣",
	tab = "»>",
	extends = "»",
	precedes = "«",
	eol = "↲",
}
-- indentation
vim.opt.tabstop = 4 -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4 -- Number of spaces for each level of indentation
vim.opt.softtabstop = 4 -- Number of spaces a <Tab> or <BS> uses while editing
-- misc
vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim.
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true
vim.opt.updatetime = 250 -- Decrease update time

-- remove the sql dynamic completion attempt in .sql files
vim.g.omni_sql_default_compl_type = "syntax"

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("x", "<leader>p", [["_dP]]) -- greatest remap ever

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Open all diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>Q", vim.diagnostic.setloclist, { desc = "Open buffer diagnostic [Q]uickfix list" })

-- File Explorer
vim.keymap.set("n", "<leader>er", "<CMD>Rex<CR>", { desc = "[E]xplore [R]ex" })
vim.keymap.set("n", "<leader>ep", "<CMD>Explore .<CR>", { desc = "[E]xplore [P]roject" })
vim.keymap.set("n", "<leader>ef", "<CMD>Explore<CR>", { desc = "[E]xplore [F]ile" })

-- Execute lua keymaps
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute current lua file" })
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Execute current lua line" })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Execute selected lua" })

-- Navigate diagnostics
local next_diag = function()
	vim.diagnostic.jump({ count = 1, float = true })
end
local prev_diag = function()
	vim.diagnostic.jump({ count = -1, float = true })
end
vim.keymap.set({ "n", "x", "o" }, "[d", prev_diag, { desc = "Prev diagnostic" })
vim.keymap.set({ "n", "x", "o" }, "]d", next_diag, { desc = "Next diagnostic" })

-- Create missing directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(ctx)
		local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
		if vim.fn.isdirectory(dir) == 0 then
			vim.fn.mkdir(dir, "p")
		end
	end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Listen to a godot host file
-- This makes the nvim jump to correct line and file when file chosen in godot editor
local projectfile = vim.fn.getcwd() .. "/project.godot"
if vim.fn.filereadable(projectfile) == 1 then
	vim.fn.serverstart("./godothost")
end

-- Install Lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	rocks = {
		enabled = false, -- Disable LuaRocks support entirely
	},
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
