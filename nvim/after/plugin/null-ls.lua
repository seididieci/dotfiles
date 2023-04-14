local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettierd.with({
      filetypes = { "html", "vue", "svelte" },
    }),
    null_ls.builtins.diagnostics.eslint,
  },
})
