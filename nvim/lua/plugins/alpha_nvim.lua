return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Center the header
		dashboard.section.header.opts.hl = "AlphaHeader"

		-- Buttons with icons
		dashboard.section.buttons.val = {
			dashboard.button("f", "󰈞     Find file", ":Telescope find_files <CR>"),
			dashboard.button("r", "󰄉     Recent files", ":Telescope oldfiles <CR>"),
			dashboard.button("q", "󰅚     Quit", ":qa<CR>"),
		}

		alpha.setup(dashboard.config)
	end,
}
