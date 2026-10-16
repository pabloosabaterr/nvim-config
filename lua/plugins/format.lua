return {
	"stevearc/conform.nvim",
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true })
			end,
			mode = { "n", "v" },
			desc = "Formatear",
		},
	},
	opts = {
		formatters_by_ft = {
			c = { "clang_format" },
			cpp = { "clang_format" },
			go = { "goimports", "gofmt", stop_after_first = true },
			rust = { "rustfmt" },
			javascript = { "deno_fmt" },
			javascriptreact = { "deno_fmt" },
			typescript = { "deno_fmt" },
			typescriptreact = { "deno_fmt" },
			json = { "deno_fmt" },
			lua = { "stylua" },
		},
		default_format_opts = { lsp_format = "fallback" },
	},
}
