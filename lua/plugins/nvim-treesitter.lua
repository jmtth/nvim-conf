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
				},
			},
		})
		vim.treesitter.language.register("html", "ejs")
	end,
	"nvim-treesitter/playground",
	cmd = "TSPlaygroundToggle",
}
