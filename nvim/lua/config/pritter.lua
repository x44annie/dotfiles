-- In lua/config/lazy.lua or appropriate plugins config file

return {
  {
    "MunifTanjim/prettier.nvim",
    config = function()
      local prettier = require("prettier")
      prettier.setup({
        bin = "prettier",
        filetypes = {
          "javascript",
          "typescript",
          "json",
          "javascriptreact", -- .jsx
          "typescriptreact", -- .tsx
          "mjs",
        },
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.js", "*.ts", "*.json", "*.jsx", "*.tsx", "*.mjs" },
        callback = function()
          vim.cmd("Prettier")
        end,
      })
    end,
    ft = { "javascript", "typescript", "json", "javascriptreact", "typescriptreact", "mjs" },
  },
}
