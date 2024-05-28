-- See `:help gitsigns` to understand what the configuration keys do
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
		vim.keymap.set("n", "[g", "<cmd>lua require('gitsigns').prev_hunk()<CR>", { silent = true })
		vim.keymap.set("n", "]g", "<cmd>lua require('gitsigns').next_hunk()<CR>", { silent = true })
	end,
}
