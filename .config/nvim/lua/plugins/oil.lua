return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		default_file_explorer = false,
		view_options = {
			show_hidden = true,
		},
	},
	keys = {
		{ "-", "<CMD>Oil<CR>", { mode = "n", desc = "Open parent directory" } },
	},
}
