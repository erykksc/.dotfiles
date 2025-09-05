return {
	-- Adds git related signs to the gutter, as well as utilities for managing changes
	"lewis6991/gitsigns.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "master",
		},
	},
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

		-- treesitter repeatable moves
		local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

		-- Wrap the two motions so the plugin can remember them
		local next_hunk, prev_hunk = ts_repeat_move.make_repeatable_move_pair(function()
			gitsigns.nav_hunk("next", { wrap = false, target = "all" })
		end, function()
			gitsigns.nav_hunk("prev", { wrap = false, target = "all" })
		end)

		-- Your normal hunk mappings, now repeatable with ; and ,
		vim.keymap.set({ "n", "x", "o" }, "]h", next_hunk, { desc = "Next [H]unk" })
		vim.keymap.set({ "n", "x", "o" }, "[h", prev_hunk, { desc = "Prev [H]unk" })
		vim.keymap.set(
			{ "n", "x", "o" },
			"<leader>hp",
			gitsigns.preview_hunk,
			{ desc = "[H]unk [P]review", silent = true }
		)
	end,
}
