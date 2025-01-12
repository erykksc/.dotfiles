return { -- Adds git related signs to the gutter, as well as utilities for managing changes
	"lewis6991/gitsigns.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	},
	keys = {
		{ "[h", "<cmd>Gitsigns prev_hunk<cr>", desc = "Jump to Previous [H]unk" },
		{ "]h", "<cmd>Gitsigns next_hunk<cr>", desc = "Jump to Next [H]unk" },
		{ "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", "n", desc = "[H]unk [P]review", silent = true },
	},
}
