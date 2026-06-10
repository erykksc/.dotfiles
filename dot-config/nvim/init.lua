vim.g.mapleader = " "

vim.g.maplocalleader = " "
vim.g.have_nerd_font = true
vim.g.netrw_banner = 1
-- vim.g.netrw_liststyle = 3
vim.opt.inccommand = "split" -- Preview substitutions live, as you type!
vim.opt.cursorline = true    -- Show which line your cursor is on
vim.opt.scrolloff = 8        -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.wrap = false         -- Disable line wrapping
vim.opt.number = true        -- show absolute number on cursor line
vim.opt.swapfile = false
vim.opt.relativenumber = true
vim.opt.autocomplete = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "+1"
vim.o.winborder = "single" -- Set the floating window border (like lsp hover)
vim.opt.completeopt = { "fuzzy", "menu", "menuone", "noselect", "popup" }
vim.opt.listchars = {
	space = "·",
	trail = "·",
	nbsp = "␣",
}
-- indentation
vim.opt.tabstop = 4               -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4            -- Number of spaces for each level of indentation
vim.opt.softtabstop = 4           -- Number of spaces a <Tab> or <BS> uses while editing
-- misc
vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim.
vim.opt.undofile = true           -- Save undo history
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.diffopt = vim.opt.diffopt + { "vertical" }

vim.opt.spelllang = { 'en_us', 'de', 'pl', 'es' }

vim.keymap.set("x", "<leader>p", [["_dP]]) -- greatest remap ever
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>")
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>")

-- File Explorer
vim.keymap.set("n", "<leader>er", "<CMD>Rexplore<CR>", { desc = "[E]xplore [P]roject" })
vim.keymap.set("n", "<leader>ep", "<CMD>Explore .<CR>", { desc = "[E]xplore [P]roject" })
vim.keymap.set("n", "<leader>ef", vim.cmd.Ex, { desc = "[E]xplore [F]ile" })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function() vim.hl.on_yank() end
})

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = true },
	virtual_text = {
		spacing = 2,
		format = function(diagnostic)
			return diagnostic.message
		end,
	},
})

-- -- disable automcomplete in telescope
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		if vim.bo.buftype == "prompt" then
			vim.opt_local.autocomplete = false
		end
	end,
})

-- builtin plugins
vim.cmd.packadd("cfilter")
vim.cmd.packadd("nvim.undotree")
vim.keymap.set("n", "<leader>u", "<CMD>Undotree<CR>", { desc = "Open [U]ndo Tree" })

-- if nvim version doesn't support pack manager (versions < 0.12)
if vim.pack == nil then
	return
end


-------------------------------- PLUGINS --------------------------------
vim.pack.add({
	"https://github.com/Mofiqul/adwaita.nvim",
	"https://github.com/brianhuster/live-preview.nvim",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/mrjones2014/smart-splits.nvim",
	'https://github.com/tpope/vim-sleuth'
})

vim.opt.termguicolors = true
vim.cmd.colorscheme("adwaita")
-- vim.cmd.colorscheme("lunaperche")

require("oil").setup({
	default_file_explorer = false,
})

-- plugin: smart-splits.nvim
local smart_splits = require("smart-splits")
smart_splits.setup({
	-- Kitty cannot expose enough layout information for edge wrapping.
	at_edge = "stop",
})
vim.keymap.set("n", "<A-h>", smart_splits.move_cursor_left, { desc = "Move to left split" })
vim.keymap.set("n", "<A-j>", smart_splits.move_cursor_down, { desc = "Move to lower split" })
vim.keymap.set("n", "<A-k>", smart_splits.move_cursor_up, { desc = "Move to upper split" })
vim.keymap.set("n", "<A-l>", smart_splits.move_cursor_right, { desc = "Move to right split" })

require("erykksc.conform")
require("erykksc.gitsigns")
require("erykksc.lint")
require("erykksc.treesitter")
require("erykksc.telescope")
require("erykksc.fff")
require("erykksc.lsp")
