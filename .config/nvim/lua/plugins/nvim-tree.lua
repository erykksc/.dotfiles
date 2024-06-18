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
		vim.keymap.set(
			"n",
			"<leader>ef",
			"<cmd>NvimTreeFindFileToggle<CR>",
			{ desc = "File [E]xplorer [F]ind File Toggle" }
		)
		vim.keymap.set(
			"n",
			"<leader>ew",
			require("nvim-tree.api").tree.collapse_all,
			{ desc = "File [E]xplorer [W]rap (Collapse)" }
		)
		vim.keymap.set("n", "<leader>er", require("nvim-tree.api").tree.reload, { desc = "File [E]xplorer [R]efresh" })
	end,
}
