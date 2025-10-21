return {
	"sindrets/diffview.nvim",
	config = function()
		require("diffview").setup({
			view = {
				default = {
					layout = "diff2_horizontal",
					winbar_info = true,
				},
				merge_tool = {
					layout = "diff3_horizontal",
					disable_diagnostics = true,
					winbar_info = true,
				},
				file_history = {
					layout = "diff2_horizontal",
					winbar_info = true,
				},
			},
			file_panel = {
				listing_style = "tree",
				tree_options = {
					flatten_dirs = true,
					folder_statuses = "only_folded",
				},
				win_config = {
					position = "left",
					width = 35,
					win_opts = {},
				},
			},
		})
	end,
}
