return {
	"ray-x/lsp_signature.nvim",
	event = "VeryLazy",
	opts = {
		hint_enable = true,
		floating_window = false,
		handler_opts = {
			border = "none", -- double, rounded, single, shadow, none, or a table of borders
		},
	},
	config = function(_, opts)
		require("lsp_signature").setup(opts)
	end,
}
