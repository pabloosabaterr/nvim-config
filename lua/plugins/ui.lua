return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				integrations = {
					blink_cmp = true,
					fzf = true,
					which_key = true,
					dap = true,
					diffview = true,
					gitsigns = true,
					render_markdown = true,
					treesitter_context = true,
				},
			})
			vim.cmd.colorscheme("catppuccin-macchiato")
		end,
	},

	{
		"nvim-mini/mini.icons",
		lazy = true,
		opts = {},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = { options = { theme = "catppuccin" } },
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			spec = {
				{ "<leader>c", group = "código" },
				{ "<leader>d", group = "debug" },
				{ "<leader>g", group = "git" },
				{ "<leader>i", group = "inlay hints" },
				{ "<leader>o", group = "organizar" },
			},
		},
	},

	{
		"stevearc/oil.nvim",
		lazy = false, -- para que `nvim .` abra oil
		opts = {
			default_file_explorer = true,
			view_options = { show_hidden = true },
		},
		keys = {
			{ "-", "<cmd>Oil<CR>", desc = "Directorio padre" },
		},
	},

	{
		"akinsho/toggleterm.nvim",
		keys = { { ",t", desc = "Terminal" } },
		opts = {
			open_mapping = [[,t]],
			insert_mappings = false,
			direction = "horizontal",
			size = 15,
		},
	},

	{ "compnerd/arm64asm-vim", ft = "arm64asm" },
}
