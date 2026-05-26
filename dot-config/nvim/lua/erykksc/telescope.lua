-- plugin: telescope
vim.pack.add({
	{
		src = "https://github.com/nvim-telescope/telescope.nvim",
		version = vim.version.range("0.1.*"),
	},
	"https://github.com/nvim-lua/plenary.nvim", --depencency
})

require("telescope").setup({})
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "Telescope all builtin" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
-- vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sa", function()
	builtin.find_files({
		hidden = true,
		no_ignore = true,
	})
end, { desc = "[S]earch All [F]iles" })
-- vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
-- vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch by [w]ord(string)" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch [B]uffers" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "[S]earch in current buffer" })
