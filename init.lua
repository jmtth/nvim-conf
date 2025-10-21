require("config.lazy")
require("config.keymaps")
require("config.options")
require("module.togglelsp")
require("module.toggle-clangtidy")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "h", "hpp", "cc", "cxx", "tpp" },
	callback = function()
		vim.b.did_ftplugin = true -- Empêche sleuth d'agir
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.expandtab = true
	end,
})
