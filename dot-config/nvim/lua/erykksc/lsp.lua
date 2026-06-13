-- plugin: LSP
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	-- Automatically install LSPs and related tools to stdpath for Neovim
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim", --translate between mason and lspconfig
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	-- Useful status updates for LSP.
	"https://github.com/j-hui/fidget.nvim",
	-- Allows extra capabilities provided by blink.cmp
	-- "https://github.com/saghen/blink.cmp",
})
require("fidget").setup()

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local teleBuiltin = require("telescope.builtin")
		-- In this case, we create a function that lets us more easily define mappings specific
		-- for LSP related items. It sets the mode, buffer and description for us each time.
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Jump to the definition of the word under your cursor.
		--  This is where a variable was first declared, or where a function is defined, etc.
		--  To jump back, press <C-t>.
		--  NOTE: it seems that it is the same as ctrl+]
		map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header.
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		-- Fuzzy find all the symbols in your current document.
		--  Symbols are things like variables, functions, types, etc.
		map("gO", teleBuiltin.lsp_document_symbols, "Open Document Symbols")

		-- Fuzzy find all the symbols in your current workspace.
		--  Similar to document symbols, except searches over your entire project.
		map("gW", teleBuiltin.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end
	end,
})

-- Listen to a godot host file
-- This makes the nvim jump to correct line and file when file chosen in godot editor
local projectfile = vim.fn.getcwd() .. "/project.godot"
if vim.fn.filereadable(projectfile) == 1 then
	vim.fn.serverstart("./godothost")
end

-- See `:help lspconfig-all` for a list of all the pre-configured LSPs
local servers = {
	arduino_language_server = {},
	astro = {
		before_init = function(_, config)
			local tsdk = vim.fs.joinpath(config.root_dir or vim.fn.getcwd(), "node_modules", "typescript", "lib")
			config.init_options = config.init_options or {}
			config.init_options.typescript = config.init_options.typescript or {}
			config.init_options.typescript.tsdk = tsdk
		end,
	},
	bashls = {},
	docker_language_server = {},
	denols = {},
	gopls = {},
	golangci_lint_ls = {},
	html = {},
	cssls = {},
	-- htmx = {},
	jsonls = {},
	jdtls = {},
	lua_ls = {
		settings = {
			Lua = {
				workspace = {
					checkThirdParty = false,
					library = {
						vim.fn.stdpath("data") .. "/site/pack/core/opt/wezterm-types/lua",
					},
				},
			},
		},
	},
	-- ltex_plus = {},
	pyright = {},
	ruff = {},
	rust_analyzer = {},
	-- tofu_ls = {},
	terraformls = {},
	ts_ls = {},
	tinymist = {},
	svelte = {},
	texlab = {},
	templ = {},
	yamlls = {},
	vacuum = {},
	matlab_ls = {},
	zls = {},
}

-- Ensure the servers and tools above are installed
require("mason").setup()

-- Make mason-tool-installer install tools
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
	"shfmt",
	"prettierd",
	"golangci-lint",
}) -- add additional tools like formatters
require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

-- Define LSPs that don't need automatic installation
-- servers.clangd = {
-- 	cmd = { "clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy" },
-- 	capabilities = { offsetEncoding = "utf-8" },
-- 	root_dir = function()
-- 		return vim.fn.getcwd()
-- 	end,
-- }
servers.clangd = {}
servers.gdscript = {}

-- configure and enable the LSPs
for server_name, server_config in pairs(servers) do
	vim.lsp.config(server_name, server_config)
	vim.lsp.enable(server_name)
end
