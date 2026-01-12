return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		local os_name = vim.loop.os_uname().sysname
		local clang_format_command

		if os_name == "Linux" then
			clang_format_command = "/home/jhervoch/.local/bin/clang-format"
		else
			clang_format_command = "/opt/homebrew/opt/llvm/bin/clang-format"
		end

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				-- Pour tes projets Solidity (vu ton profil)
				-- solidity = { "forge_fmt" },
				-- Support EJS
				ejs = { "prettierd", "prettier", stop_after_first = true },
				solidity = { "prettier", "prettierd", stop_after_first = true },

				-- Tous les filetypes C/C++
				c = { "clang-format" },
				cpp = { "clang-format" },
				h = { "clang-format" },
				hpp = { "clang-format" },
				cc = { "clang-format" },
				cxx = { "clang-format" },
				tpp = { "clang-format" },
			},
			formatters = {
				["clang-format"] = {
					command = clang_format_command,
					args = {
						"--style=file", -- Utilise le .clang-format du projet
						"--assume-filename=$FILENAME", -- Important pour la détection du langage
					},
					stdin = true,
				},
				prettier = {
					prepend_args = function(self, ctx)
						if vim.bo[ctx.buf].filetype == "solidity" then
							return { "--plugin", "prettier-plugin-solidity" }
						end
						return {}
					end,
				},
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
	end,
}
