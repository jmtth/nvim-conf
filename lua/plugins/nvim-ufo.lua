return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	event = "BufReadPost",
	config = function()
		-- Force l'affichage d'une colonne de fold
		vim.opt.foldcolumn = "1"
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
		vim.opt.foldenable = false -- ne rien plier à l'ouverture

		require("ufo").setup({
			provider_selector = function()
				return { "treesitter", "indent" }
			end,
			fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = ("  %d "):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local hlGroup = chunk[2]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
						curWidth = curWidth + chunkWidth
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						table.insert(newVirtText, { chunkText, hlGroup })
						break
					end
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end,
			open_fold_hl_timeout = 150,
			enable_get_fold_virt_text = true,
		})

		-- Flèches dans la colonne de fold
		vim.fn.sign_define("UfoFolded", { text = "▶", texthl = "FoldColumn" })
		vim.fn.sign_define("UfoOpened", { text = "▼", texthl = "FoldColumn" })

		-- Commandes utiles
		vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Ouvrir tous les folds" })
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Fermer tous les folds" })
	end,
}
