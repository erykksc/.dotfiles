return {
	"nvim-mini/mini.nvim",
	version = false,
	config = function()
		require("mini.icons").setup()
		local pick = require("mini.pick")
		pick.setup({})
		local extra = require("mini.extra")

		vim.keymap.set("n", "<leader>sh", pick.builtin.help, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", extra.pickers.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sf", pick.builtin.files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>sg", pick.builtin.grep_live, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", extra.pickers.diagnostic, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", pick.builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>sb", pick.builtin.buffers, { desc = "[S]earch [B]uffers" })
		vim.keymap.set("n", "<leader>/", function()
			extra.pickers.buf_lines({ scope = "current" })
		end, { desc = "[S]earch in current buffer" })
		vim.keymap.set("n", "<leader>s/", extra.pickers.buf_lines, { desc = "[S]earch in all buffers" })
	end,
}
