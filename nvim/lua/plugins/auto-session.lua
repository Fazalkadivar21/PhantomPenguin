return {
	"rmagatti/auto-session",
	lazy = false,
    config = function()
        require("auto-session").setup {
            log_level = "error",
            auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        }
        vim.keymap.set("n", "<leader>ss", function() require("auto-session").SaveSession() end, { desc = "Save Session" })
        vim.keymap.set("n", "<leader>ls", function() require("auto-session").LoadSession() end, { desc = "Load Session" })
        vim.keymap.set("n", "<leader>ds", function() require("auto-session").DeleteSession() end, { desc = "Delete Session" })
    end,
}
