-- lua/module/toggle-fold-methods.lua
-- <leader>fm : toggle fold pour toutes les fonctions / méthodes (multilignes)

local M = {}

-- Renvoie les blocs "function" ou "method" via Treesitter
local function iter_function_blocks(bufnr)
	local parser = vim.treesitter.get_parser(bufnr)
	if not parser then
		return function() end
	end
	local tree = parser:parse()[1]
	if not tree then
		return function() end
	end
	local root = tree:root()

	local ft = vim.bo[bufnr].filetype
	local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
	if not ok or not lang then
		return function() end
	end

	-- Capture les fonctions, méthodes, classes ou blocks similaires selon les langages
	local query = vim.treesitter.query.parse(
		lang,
		[[
    [(function_definition) @fn
     (function_declaration) @fn
     (method_definition) @fn
     (function_item) @fn]
  ]]
	)

	local ranges = {}
	for _, node in query:iter_captures(root, bufnr, 0, -1) do
		local s, _, e, _ = node:range()
		if e > s then
			table.insert(ranges, { s, e })
		end
	end

	local i = 0
	return function()
		i = i + 1
		local r = ranges[i]
		if not r then
			return nil
		end
		return r[1] + 1, r[2] + 1
	end
end

function M.toggle()
	local bufnr = 0
	local was = vim.b.methods_folded or false
	vim.b.methods_folded = not was

	vim.opt_local.foldmethod = "manual"
	vim.opt_local.foldenable = true
	vim.cmd("silent! normal! zE")

	if vim.b.methods_folded then
		for s, e in iter_function_blocks(bufnr) do
			if s and e and e > s then
				vim.cmd(("%d,%dfold"):format(s, e))
			end
		end
		vim.notify("Méthodes/Fonctions repliées", vim.log.levels.INFO)
	else
		vim.notify("Méthodes/Fonctions dépliées", vim.log.levels.INFO)
	end
end

-- Mapping + which-key
vim.keymap.set("n", "<leader>fm", M.toggle, { desc = "Toggle fold fonctions/méthodes" })

pcall(function()
	require("which-key").add({
		{ "<leader>f", group = "+fold" },
		{ "<leader>fm", desc = "Toggle fold fonctions/méthodes" },
	})
end)

return M
