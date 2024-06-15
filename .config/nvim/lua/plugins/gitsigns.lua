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
		vim.keymap.set("n", "[g", require("gitsigns").prev_hunk, { desc = "Previous Git Hunk" })
		vim.keymap.set("n", "]g", require("gitsigns").next_hunk, { desc = "Next Git Hunk" })
		vim.keymap.set("n", "<leader>ph", require("gitsigns").preview_hunk, { silent = true })
	end,
}
