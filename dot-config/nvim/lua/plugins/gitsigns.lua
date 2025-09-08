return {
	"lewis6991/gitsigns.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	config = function()
		local gitsigns = require("gitsigns")
		gitsigns.setup({
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		})

		-- Your normal hunk mappings, now repeatable with ; and ,
		vim.keymap.set({ "n" }, "[h", "<CMD>Gitsigns prev_hunk<CR>", { desc = "Next [H]unk" })
		vim.keymap.set({ "n" }, "]h", "<CMD>Gitsigns next_hunk<CR>", { desc = "Prev [H]unk" })
		vim.keymap.set({ "n" }, "<leader>hp", gitsigns.preview_hunk, { desc = "[H]unk [P]review", silent = true })
	end,
}
