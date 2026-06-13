-- plugin: conform
vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "[F]ormat buffer" })

require("conform").setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		-- Disable "format_on_save lsp_fallback" for languages that don't
		-- have a well standardized coding style. You can add additional
		-- languages here or re-enable it for the disabled ones.
		local disable_filetypes = { c = true, cpp = true }
		if disable_filetypes[vim.bo[bufnr].filetype] then
			return nil
		else
			return {
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		end
	end,
	formatters_by_ft = {
		bash = { "shfmt" },
		caddy = { "caddy" },
		dockerfile = { "remove_trailing_whitespace" },
		lua = { "stylua" },
		python = function(bufnr)
			if require("conform").get_formatter_info("ruff_format", bufnr).available then
				return { "ruff_fix", "ruff_format" }
			else
				return { "isort", "black" }
			end
		end,

		go = { "golangci-lint" },
		nix = { "nixfmt" },
		css = { "prettierd", "prettier", stop_after_first = true },
		graphql = { "prettierd", "prettier", stop_after_first = true },
		handlebars = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		json = { "prettierd", "prettier", stop_after_first = true },
		json5 = { "prettierd", "prettier", stop_after_first = true },
		jsonc = { "prettierd", "prettier", stop_after_first = true },
		less = { "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },
		mdx = { "prettierd", "prettier", stop_after_first = true },
		rust = { "rustfmt" },
		scss = { "prettierd", "prettier", stop_after_first = true },
		svelte = { "prettierd", "prettier", stop_after_first = true },
		terraform = { "tofu_fmt" },
		tex = { "tex-fmt" },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		vue = { "prettierd", "prettier", stop_after_first = true },
		yaml = { "prettierd", "prettier", stop_after_first = true },
		zsh = { "shfmt" },
		-- Use a function as a catch-all for all other filetypes
		-- ["*"] = { "remove_trailing_whitespace" },
	},
	formatters = {
		["tex-fmt"] = {
			args = { "--nowrap", "--stdin" },
		},
		prettier_gotmpl = {
			command = "prettier",
			args = {
				"--stdin-filepath",
				"$FILENAME",
				"--plugin",
				"prettier-plugin-go-template",
				"--parser",
				"go-template",
			},
			stdin = true,
		},
		remove_trailing_whitespace = {
			command = "sed",
			args = {
				"s/[ \t]*$//",
			},
			stdin = true,
		},
		caddy = {
			command = 'caddy',
			args = { 'fmt', '-' },
			stdin = true,
		},
	},
})
