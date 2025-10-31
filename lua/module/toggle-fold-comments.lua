-- lua/module/toggle-fold-comments.lua
-- <leader>fo : toggle fold pour les blocs de commentaires multilignes

local M = {}

-- Renvoie un itérateur sur les blocs de commentaires (détectés via Treesitter)
local function iter_comment_blocks(bufnr)
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

	local query = vim.treesitter.query.parse(lang, [[ (comment) @c ]])

	-- Regroupe les commentaires contigus
	local ranges = {}
	for _, node in query:iter_captures(root, bufnr, 0, -1) do
		local s, _, e, _ = node:range()
		if #ranges == 0 then
			table.insert(ranges, { s, e })
		else
			local last = ranges[#ranges]
			if s == last[2] + 1 then
				last[2] = e
			else
				table.insert(ranges, { s, e })
			end
		end
	end

	-- Itérateur qui saute les blocs d'une seule ligne
	local i = 0
	return function()
		i = i + 1
		local r = ranges[i]
		while r and r[2] <= r[1] do
			i = i + 1
			r = ranges[i]
		end
		if not r then
			return nil
		end
		return r[1] + 1, r[2] + 1
	end
end

function M.toggle()
	local bufnr = 0
	local was = vim.b.comments_folded or false
	vim.b.comments_folded = not was

	vim.opt_local.foldmethod = "manual"
	vim.opt_local.foldenable = true
	vim.cmd("silent! normal! zE")

	if vim.b.comments_folded then
		for s, e in iter_comment_blocks(bufnr) do
			if s and e and e > s then
				vim.cmd(("%d,%dfold"):format(s, e))
			end
		end
		vim.notify("Commentaires repliés", vim.log.levels.INFO)
	else
		vim.notify("Commentaires dépliés", vim.log.levels.INFO)
	end
end

-- Mapping + groupe which-key
vim.keymap.set("n", "<leader>fo", M.toggle, { desc = "Toggle fold commentaires (multilignes)" })

pcall(function()
	require("which-key").add({
		{ "<leader>f", group = "+fold" },
		{ "<leader>fo", desc = "Toggle fold commentaires (multilignes)" },
	})
end)

return M
