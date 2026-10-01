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
vim.o.exrc = true

vim.opt.spelllang = { 'en_us', 'de', 'pl', 'es' }

vim.keymap.set("x", "<leader>p", [["_dP]]) -- greatest remap ever
vim.keymap.set("n", "<C-k>", vim.cmd.cprev)
vim.keymap.set("n", "<C-j>", vim.cmd.cnext)
vim.keymap.set("n", "<leader>m", vim.cmd.make)

-- File Explorer
vim.keymap.set("n", "<leader>er", vim.cmd.Rexplore, { desc = "[E]xplore [P]roject" })
vim.keymap.set("n", "<leader>ep", "<CMD>Explore .<CR>", { desc = "[E]xplore [P]roject" })
vim.keymap.set("n", "<leader>ef", vim.cmd.Ex, { desc = "[E]xplore [F]ile" })

-- builtin harpoon
vim.keymap.set('n', '<leader>a', function()
	vim.cmd('$argadd %')
	vim.cmd('argdedup')
end)
vim.keymap.set('n', '<C-1>', function() vim.cmd('silent! 1argument') end)
vim.keymap.set('n', '<C-2>', function() vim.cmd('silent! 2argument') end)
vim.keymap.set('n', '<C-3>', function() vim.cmd('silent! 3argument') end)
vim.keymap.set('n', '<C-4>', function() vim.cmd('silent! 4argument') end)
vim.keymap.set('n', '<C-5>', function() vim.cmd('silent! 5argument') end)

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

-- if nvim version doesn't support pack manager (versions < 0.12)
if vim.pack == nil then
	return
end

vim.opt.autocomplete = true
vim.opt.complete = "o,.,w,b,u,t"
vim.cmd.packadd("nvim.undotree")
vim.keymap.set("n", "<leader>u", vim.cmd.Undotree, { desc = "Open [U]ndo Tree" })

-------------------------------- PLUGINS --------------------------------
vim.pack.add({
	"https://github.com/edeneast/nightfox.nvim",
	"https://github.com/brianhuster/live-preview.nvim",
	'https://github.com/tpope/vim-sleuth'
})

vim.opt.termguicolors = true

vim.api.nvim_create_autocmd('OptionSet', {
	pattern = 'background',
	callback = function()
		if vim.v.option_new == 'dark' then
			vim.cmd.colorscheme('nordfox')
		else
			vim.cmd.colorscheme('dayfox')
		end
	end,
})

if vim.opt.background:get() == "light" then
	vim.cmd.colorscheme("dayfox")
else
	vim.cmd.colorscheme("nordfox")
end

require("erykksc.conform")
require("erykksc.gitsigns")
require("erykksc.lint")
require("erykksc.treesitter")
require("erykksc.telescope")
require("erykksc.fff")
require("erykksc.lsp")
