return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-neotest/neotest",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"thenbe/neotest-playwright",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-playwright").adapter({
					options = {
						persist_project_selection = true,
						enable_dynamic_test_discovery = true,
					},
				}),
			},
		})
		vim.keymap.set("n", "<leader>tn", function()
			require("neotest").run.run()
		end, { desc = "Run [N]earest test" })

		vim.keymap.set("n", "<leader>tf", function()
			require("neotest").run.run(vim.fn.expand("%"))
		end, { desc = "Run tests in [file]" })
		-- debug neareest test using leader tN
		vim.keymap.set("n", "<leader>tN", function()
			require("neotest").run.run({ strategy = "dap" })
		end, { desc = "Debug nearest test" })

		vim.keymap.set("n", "<leader>ts", function()
			require("neotest").summary.toggle()
		end, { desc = "show tests" })
	end,
}
