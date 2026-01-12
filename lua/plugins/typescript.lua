return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {
		settings = {
			-- formatage géré ailleurs (Conform)
			expose_as_code_action = "all",

			tsserver_format_options = {
				allowIncompleteCompletions = false,
				allowRenameOfImportPath = true,
			},

			-- 🔑 ICI est la clé
			diagnostics = {
				-- Désactive la source "typescript" (checker)
				-- Garde uniquement tsserver
				disable = {
					"typescript",
				},
			},
		},

		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end,
	},
}
