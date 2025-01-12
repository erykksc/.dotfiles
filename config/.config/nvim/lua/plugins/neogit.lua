return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration

		-- Only one of these is needed.
		"nvim-telescope/telescope.nvim", -- optional
	},
	opts = {
		kind = "replace",
	},
	config = true,
	keys = {
		{ "<leader>gs", "<cmd>Neogit<CR>", desc = "Open git status" },
	},
}
