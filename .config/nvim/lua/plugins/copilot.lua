return {
	{
		"github/copilot.vim",
		config = function()
			vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
			})
			vim.g.copilot_no_tab_map = true
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" },
		},
		opts = {
			debug = false,
			auto_insert_mode = true,
		},
		-- Quick chat with Copilot
		vim.keymap.set({ "n", "x" }, "<leader>aq", function()
			local input = vim.fn.input("Quick Chat: ")
			if input ~= "" then
				require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
			end
		end, { desc = "[A]sk quick chat" }),

		vim.keymap.set({ "n", "x" }, "<leader>at", "<cmd>CopilotChatToggle<CR>", { desc = "[A]sk Copilot [T]oggle" }),
		vim.keymap.set({ "n", "x" }, "<leader>ar", "<cmd>CopilotChatReview<CR>", { desc = "[A]sk for [R]eview" }),
		vim.keymap.set({ "n", "x" }, "<leader>ae", "<cmd>CopilotChatExplain<CR>", { desc = "[A]sk to [E]xplain" }),
		vim.keymap.set(
			{ "n", "x" },
			"<leader>ac",
			"<cmd>CopilotChatCommitStaged<CR>",
			{ desc = "[A]sk for [C]ommit Message of Staged" }
		),
	},
}
