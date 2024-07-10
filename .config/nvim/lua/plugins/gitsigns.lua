return { -- Adds git related signs to the gutter, as well as utilities for managing changes
	"lewis6991/gitsigns.nvim",
	lazy = false,
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
		{ "<leader>ph", "<cmd>Gitsigns preview_hunk<cr>", "n", desc = "[P]review [H]unk", silent = true },
	},
}
