return {
	"williamboman/mason.nvim",
	-- not VeryLazy: mason must put its bin/ on PATH and mason-lspconfig must
	-- vim.lsp.enable() the servers before the first buffer's FileType fires,
	-- or that buffer gets no LSP. Still skips startup for `nvim` with no file.
	event = { "BufReadPre", "BufNewFile" },
	cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog", "MasonToolsInstall", "MasonToolsUpdate" },
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- mason-lspconfig defaults to automatic_enable = true, which calls
			-- vim.lsp.enable() for every installed server.
			--
			-- jdtls: nvim-jdtls (plugins/lsp/jdtls.lua) starts its own jdtls
			-- client, with the lombok javaagent and the java-debug/java-test
			-- bundles that DAP needs. Auto-enabling lspconfig's plain jdtls makes
			-- both race to start on the first java buffer. They currently resolve
			-- to the same root (code/km-pnp via mvnw) so nvim reuses one client
			-- rather than spawning two, but whichever registers first wins - and
			-- if that is lspconfig's, the javaagent and bundles are silently
			-- absent. Excluding it makes nvim-jdtls the sole, deterministic owner.
			--
			-- graphql: graphql-language-service-server hard-fails initialize in any
			-- repo with .graphql files but no graphql.config.*/.graphqlrc* at the
			-- root. Excluded to match coc's "graphql.filetypes": [] in
			-- vim/coc-settings.json. Re-enable by removing it here and adding a
			-- graphql config to the repo.
			automatic_enable = {
				exclude = { "jdtls", "graphql" },
			},
			-- list of servers for mason to install
			ensure_installed = {
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				"clangd",
				"jdtls",
				"bashls",
				"jsonls",
				"yamlls",
				"marksman",
				"dockerls",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint", -- python linter
				"eslint_d", -- js linter
			},
		})
	end,
}
