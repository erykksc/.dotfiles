-- plugin: nvim-lint
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

require("lint").linters_by_ft = {
	yaml = { "redocly" },
}

local try_lint = function()
	require("lint").try_lint({}, {
		ignore_errors = true,
	})
end
vim.api.nvim_create_autocmd({ "BufWritePost" }, { callback = try_lint })
vim.api.nvim_create_autocmd({ "BufReadPost" }, { callback = try_lint })
