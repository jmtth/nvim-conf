return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	keys = {
		{ "<leader>f", desc = "+fold" },
		{
			"<leader>fo",
			function()
				require("fold_comments").toggle()
			end,
			desc = "Toggle fold: multiline comments",
			mode = "n",
		},
	},
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"elixir",
				"heex",
				"javascript",
				"typescript",
				"tsx",
				"html",
				"cpp",
				"python",
				"bash",
				"solidity",
			},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<Enter>",
					node_incremental = "<Enter>",
					scope_incremental = false,
					node_decremental = "<Backspace>",
		--merge conflict
		-- local install = require("nvim-treesitter.install")
		-- install.prefer_git = true
		-- -- Force l'utilisation de cc (souvent clang à 42)
		-- require("nvim-treesitter.install").prefer_git = true
		-- require("nvim-treesitter.install").compilers = { "cc", "clang", "gcc" }
		-- -- Utilisation de pcall pour éviter un crash si le module est absent
		-- local status, configs = pcall(require, "nvim-treesitter.configs")
		--
		-- -- Si le module existe (ancienne version ou compatibilité)
		-- if status then
		-- 	configs.setup({
		-- 		ensure_installed = {
		-- 			"c",
		-- 			-- "lua",
		-- 			"vim",
		-- 			"vimdoc",
		-- 			"query",
		-- 			"javascript",
		-- 			"html",
		-- 			"cpp",
		-- 			"python",
		-- 			"bash",
		-- 			-- "solidity",
				},
				sync_install = false, -- NE PAS installer de façon synchrone au démarrage
				auto_install = false, -- Désactive l'installation auto pour éviter les blocages
				-- highlight = { enable = true },
				highlight = {
					enable = true,
					-- Ajoute cette ligne pour ignorer les buffers spéciaux
					disable = { "lua", "neo-tree" },
				},
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<Enter>",
						node_incremental = "<Enter>",
						scope_incremental = false,
						node_decremental = "<Backspace>",
					},
				},
			})
		else
			-- Nouvelle méthode si 'nvim-treesitter.configs' n'existe plus
			-- La plupart des options passent maintenant par le coeur de Nvim
			-- ou sont gérées automatiquement par le plugin.
			vim.notify("Nvim-Treesitter: utilisation de la nouvelle méthode de chargement", vim.log.levels.INFO)
		end

		-- Enregistrement du type de fichier ejs
		vim.treesitter.language.register("html", "ejs")
	end,
}
-- return {
--     "nvim-treesitter/nvim-treesitter",
--     build = ":TSUpdate",
--     config = function()
--         -- On force l'utilisation de clang (standard à 42)
--         require('nvim-treesitter.install').compilers = { "clang" }
--
--         require("nvim-treesitter.configs").setup({
--             -- On ne force rien à l'installation pour éviter les freezes
--             ensure_installed = {},
--             sync_install = false,
--             auto_install = false,
--             highlight = {
--                 enable = true,
--                 -- ON DÉSACTIVE LUA ET NEO-TREE
--                 -- C'est ce qui arrêtera les messages d'erreur rouges
--                 disable = { "lua", "neo-tree" },
--             },
--         })
--     end,
-- }
