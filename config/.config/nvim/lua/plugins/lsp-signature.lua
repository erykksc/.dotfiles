return {
	"ray-x/lsp_signature.nvim",
	event = "VeryLazy",
	opts = {
		hint_enable = false,
		floating_window = true,
		handler_opts = {
			border = "single", -- double, rounded, single, shadow, none, or a table of borders
		},
		toggle_key = "<C-k>",
		toggle_key_flip_floatwin_setting = true,
	},
	config = function(_, opts)
		require("lsp_signature").setup(opts)
	end,
}
