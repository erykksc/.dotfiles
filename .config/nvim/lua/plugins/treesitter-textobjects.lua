return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup({
			textobjects = {
				lsp_interop = {
					enable = true,
					border = "none",
					floating_preview_opts = {},
					peek_definition_code = {
						["<leader>pf"] = "@function.outer",
						["<leader>pc"] = "@class.outer",
					},
				},
			},
		})
	end,
}