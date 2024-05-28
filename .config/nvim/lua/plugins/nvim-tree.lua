return {
	"nvim-tree/nvim-tree.lua",
	config = function()
		require("nvim-tree").setup({
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 30,
			},
			renderer = {
				group_empty = true,
			},
			filters = {
				enable = false,
			},
		})

		vim.keymap.set("n", "<leader>et", require("nvim-tree.api").tree.toggle, { desc = "File [E]xplorer [T]oggle" })
		vim.keymap.set("n", "<leader>ef", require("nvim-tree.api").tree.focus, { desc = "File [E]xplorer [F]ocus" })
	end,
}
