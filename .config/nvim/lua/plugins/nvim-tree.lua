return {
	"nvim-tree/nvim-tree.lua",
	opts = {
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
	},
	keys = {
		{ "<leader>et", "<cmd>NvimTreeToggle<CR>", desc = "File [E]xplorer [T]oggle" },
		{ "<leader>ef", "<cmd>NvimTreeFindFile<CR>", desc = "File [E]xplorer [F]ind File" },
		{
			"<leader>ew",
			function()
				require("nvim-tree.api").tree.collapse_all()
			end,
			desc = "File [E]xplorer [W]rap (Collapse)",
		},
		{
			"<leader>er",
			function()
				require("nvim-tree.api").tree.reload()
			end,
			desc = "File [E]xplorer [R]efresh",
		},
	},
}
