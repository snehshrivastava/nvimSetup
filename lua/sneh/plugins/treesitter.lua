local parsers = {
  "json",
  "javascript",
  "typescript",
  "tsx",
  "yaml",
  "html",
  "css",
  "prisma",
  "markdown",
  "markdown_inline",
  "svelte",
  "graphql",
  "bash",
  "lua",
  "vim",
  "dockerfile",
  "gitignore",
  "query",
  "vimdoc",
  "c",
  "cpp",
  "python",
  "go",
  "java",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    require("nvim-treesitter").setup()
    require("nvim-treesitter").install(parsers)
    require("nvim-ts-autotag").setup()

    local ft_patterns = vim.tbl_filter(function(p)
      return p ~= "tsx" and p ~= "vimdoc" and p ~= "markdown_inline"
    end, parsers)
    vim.list_extend(ft_patterns, { "typescriptreact", "help" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = ft_patterns,
      callback = function()
        vim.treesitter.start()
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end,
    })
  end,
}
