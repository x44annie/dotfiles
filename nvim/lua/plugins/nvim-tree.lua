return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = {
          highlight_git = true,
          highlight_opened_files = "all",
        },
        filters = { dotfiles = false },
      })

      -- keymap for opening nvim-tree
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
    end,
  },
}
