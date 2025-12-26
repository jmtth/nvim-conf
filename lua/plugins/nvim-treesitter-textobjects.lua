return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	lazy = true,
	config = function()
		-- On ne fait plus require('nvim-treesitter.configs').setup() ici
		-- La configuration se fait généralement à l'intérieur du plugin principal nvim-treesitter
	end,
}
