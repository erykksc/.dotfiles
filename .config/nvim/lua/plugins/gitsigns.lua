return { -- Adds git related signs to the gutter, as well as utilities for managing changes
	"lewis6991/gitsigns.nvim",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		})
		vim.keymap.set("n", "[c", require("gitsigns").prev_hunk, { desc = "Jump to Previous [C]hange" })
		vim.keymap.set("n", "]c", require("gitsigns").next_hunk, { desc = "Jump to Next [C]hange" })
		vim.keymap.set("n", "<leader>ph", require("gitsigns").preview_hunk, { silent = true })
	end,
}
