return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {
		settings = {
			-- On désactive le formatage ici aussi pour laisser Conform bosser
			expose_as_code_action = "all",
			tsserver_format_options = {
				allowIncompleteCompletions = false,
				allowRenameOfImportPath = true,
			},
		},
		-- On attache les mêmes capacités et on_attach que tes autres serveurs
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			-- Ajoute ici tes raccourcis clavier si besoin
		end,
	},
}
