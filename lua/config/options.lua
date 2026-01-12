vim.opt.colorcolumn = "80"
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true --show line undercursor
vim.opt.undofile = true --store undos between sessions
vim.g.have_nerd_font = true
vim.opt.mouse = "a" --Enable mouse mode, can be useful for resizing splits for example!
vim.opt.showmode = false --Don't show the mode , since it's already in the stqtus line

vim.opt.expandtab = true --Convert tabs to spaces
vim.opt.shiftwidth = 4 -- Amount to indent with << and >>
vim.opt.tabstop = 4 -- How many spaces are shown per Tab
vim.opt.softtabstop = 4 --How many spaces are applied when pressing Tab
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true -- keep identation from previous line
vim.opt.breakindent = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.signcolumn = "yes"

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Configuration des fenêtres flottantes
vim.opt.pumheight = 15 -- Limite la hauteur du menu popup
vim.opt.pumwidth = 60 -- Limite la largeur du menu popup

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- nvim/after/ftdetect/cpp.lua
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("CustomCppDetection", {}),
	desc = "Set .ttp files to C++",
	callback = function(ev)
		if vim.fn.expand("%"):sub(-4) == ".tpp" then
			vim.api.nvim_set_option_value("filetype", "cpp", { buf = ev.buf })
		end
	end,
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = {"*.cpp", "*.hpp", "*.cc", "*.c", "*.h", "*.tpp"},
--     callback = function()
--         vim.cmd("silent! !clang-format -style=file -i " .. vim.fn.expand("%"))
--     end,
-- })

-- Hotfix nvim 0.12-dev: vim.fs.joinpath() ne tolère pas les tables
-- Certaines chaînes d'appel (vim.fs.find/root + lspconfig ts_ls) peuvent injecter {path, marker}
do
	local _root = vim.fs.root
	local _joinpath = vim.fs.joinpath

	local function to_path(v)
		if type(v) == "string" then
			return v
		end
		if type(v) == "table" then
			-- cas le plus fréquent: { "/path", "marker" }
			if type(v[1]) == "string" then
				return v[1]
			end
			-- fallback possibles
			if type(v.path) == "string" then
				return v.path
			end
		end
		return tostring(v)
	end

	vim.fs.joinpath = function(...)
		local parts = { ... }
		for i = 1, #parts do
			parts[i] = to_path(parts[i])
		end
		return _joinpath(unpack(parts))
	end

	vim.fs.root = function(path, ...)
		path = to_path(path)
		local res = _root(path, ...)
		-- nvim 0.12-dev peut retourner { root, marker }
		if type(res) == "table" then
			return to_path(res)
		end
		return res
	end
end

vim.diagnostic.config({
	virtual_text = {
		source = false, -- on ne montre pas la source par défaut
	},
})

-- 🔧 Filtre global : ignorer la source "typescript"
do
	local orig_handler = vim.diagnostic.handlers.virtual_text
	vim.diagnostic.handlers.virtual_text = {
		show = function(ns, bufnr, diagnostics, opts)
			diagnostics = vim.tbl_filter(function(d)
				return d.source ~= "typescript"
			end, diagnostics)
			orig_handler.show(ns, bufnr, diagnostics, opts)
		end,
		hide = orig_handler.hide,
	}
end
