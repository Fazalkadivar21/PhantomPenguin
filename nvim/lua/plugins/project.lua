return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      detection_methods = { "pattern", "lsp" },
      patterns = { ".git", "Makefile", "package.json", "go.mod" },
      show_hidden = false,
      silent_chdir = false,
    })
  end,
}
