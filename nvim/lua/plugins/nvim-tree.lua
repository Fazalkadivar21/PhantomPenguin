return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			view = {
				side = "right",
			},
			renderer = {
				highlight_git = true,
				icons = {
					show = {
						git = true,
					},
					glyphs = {
						git = {
							unstaged = "M",
							staged = "A",
							unmerged = "",
							renamed = "M",
							untracked = "U",
							deleted = "D",
							ignored = "◌",
						},
					},
                    git_placement = "after",
				},
			},
		})

		vim.keymap.set("n", "<leader>tt", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>tf", ":NvimTreeFocus<CR>", { noremap = true, silent = true })
	end,
}
