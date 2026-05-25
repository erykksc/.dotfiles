-- plugin: nvim-treesitter
vim.api.nvim_create_autocmd("PackChanged", {
	desc = "Handle nvim-treesitter updates",
	group = vim.api.nvim_create_augroup("nvim-treesitter-pack-changed-update-handler", { clear = true }),
	callback = function(event)
		if event.data.kind == "update" and event.data.spec.name == "nvim-treesitter" then
			vim.notify("nvim-treesitter updated, running TSUpdate...", vim.log.levels.INFO)
			---@diagnostic disable-next-line: param-type-mismatch
			local ok = pcall(vim.cmd, "TSUpdate")
			if ok then
				vim.notify("TSUpdate completed successfully!", vim.log.levels.INFO)
			else
				vim.notify("TSUpdate command not available yet, skipping", vim.log.levels.WARN)
			end
		end
	end,
})

vim.pack.add({
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
})


local treesitter = require('nvim-treesitter')
treesitter.install { "stable", "unstable" }
require('treesitter-context').setup()

vim.api.nvim_create_autocmd('FileType', {
	callback = function(args)
		if vim.treesitter.language.add(vim.bo[args.buf].filetype) then
			vim.treesitter.start(args.buf)

			-- indentation, provided by nvim-treesitter
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
	local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
	local filename = vim.fn.fnamemodify(filepath, ":t")
	return string.match(filename, ".*mise.*%.toml$") ~= nil
end, { force = true, all = false })
