return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy=false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    require("nvim-treesitter.configs").setup({
    
      ensure_installed = {
        "lua", "python","javascript","typescript","tsx","json","html","css","markdown","markdown_inline",
      },

      sync_install = false,

      auto_install = true,

      highlight = {
        enable = true,
      },

      indent = {
        enable = true,
      },
    })
  end,
}
