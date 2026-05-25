-- plugin: gitsigns
vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

local gitsigns = require("gitsigns")
-- gitsigns.setup({
-- 	signs = {
-- 		add = { text = "+" },
-- 		change = { text = "~" },
-- 		delete = { text = "_" },
-- 		topdelete = { text = "‾" },
-- 		changedelete = { text = "~" },
-- 	},
-- })

vim.keymap.set("n", "]c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "]c", bang = true })
	else
		gitsigns.nav_hunk("next")
	end
end)

vim.keymap.set("n", "[c", function()
	if vim.wo.diff then
		vim.cmd.normal({ "[c", bang = true })
	else
		gitsigns.nav_hunk("prev")
	end
end)
vim.keymap.set("n", "<leader>hl", function() require("gitsigns").setqflist("all") end)
vim.keymap.set("n", "<leader>hb", gitsigns.blame_line)
vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk)
vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk)
vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { desc = "[H]unk [P]review", silent = true })
vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { desc = "[H]unk [D]iffthis", silent = true })
