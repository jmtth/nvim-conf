return {
	"rmagatti/goto-preview",
	dependencies = { "rmagatti/logger.nvim" },
	event = "BufEnter",
	config = function()
		require("goto-preview").setup({
			width = 120, -- Largeur de la fenêtre
			height = 25, -- Hauteur de la fenêtre
			border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Bordure
			default_mappings = false, -- On désactive les mappings par défaut
			debug = false,
			opacity = nil, -- Transparence (nil = opaque)
			post_open_hook = nil,
			post_close_hook = nil,
			focus_on_open = true, -- Focaliser sur la fenêtre d'aperçu lors de l'ouverture
			dismiss_on_move = false, -- Fermer lors du déplacement du curseur
			force_close = true, -- Forcer la fermeture de la fenêtre avec échap
			bufhidden = "wipe", -- Comment gérer le buffer fermé
			stack_floating_preview_windows = true, -- Empiler les fenêtres flottantes
			preview_window_title = { enable = true, position = "left" },
		})
	end,
}
