return {
	{
		"github/copilot.vim",
		config = function()
			vim.cmd(":Copilot disable")
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
			auto_insert_mode = false,
			show_help = false,
		},
		keys = {
			{
				"<leader>ab",
				function()
					local input = vim.fn.input("Ask about Buffer: ")
					if input ~= "" then
						require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
					end
				end,
				mode = { "n", "x" },
				desc = "[A]sk about [B]uffer",
			},
			{ "<leader>at", "<cmd>CopilotChatToggle<CR>", mode = { "n", "x" }, desc = "[A]sk Copilot [T]oggle" },
			{ "<leader>ar", "<cmd>CopilotChatReview<CR>", mode = { "n", "x" }, desc = "[A]sk for [R]eview" },
			{ "<leader>ae", "<cmd>CopilotChatExplain<CR>", mode = { "n", "x" }, desc = "[A]sk to [E]xplain" },
			{
				"<leader>ac",
				"<cmd>CopilotChatCommitStaged<CR>",
				mode = { "n", "x" },
				desc = "[A]sk for [C]ommit Message of Staged",
			},
		},
	},
}
