return {
	"tpope/vim-fugitive",
	keys = {
		{ "<leader>gs", "<cmd>0G<cr>", desc = "[Git] Fugitive [S]ummary" },
		{ "<leader>gh", "<cmd>diffget //2<cr>", desc = "Get diff from the left side" },
		{ "<leader>gl", "<cmd>diffget //3<cr>", desc = "Get diff from the right side" },
	},
}
