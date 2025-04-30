return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
    "artemave/workspace-diagnostics.nvim",
    --{ "rafamadriz/friendly-snippets" },
  },

  config = function()
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities())

    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "ts_ls",
        "csharp_ls",
        "volar",
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities
          }
        end,

        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim", "it", "describe", "before_each", "after_each" },
                },
                workspace = {
                  library = { vim.env.VIMRUNTIME },
                },
              }
            }
          }
        end,
        ["ts_ls"] = function()
          local lspconfig = require("lspconfig")
          local mason_registry = require("mason-registry")
          local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
              .. "/node_modules/@vue/language-server"
          lspconfig.ts_ls.setup({
            filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
            init_options = {
              plugins = { -- I think this was my breakthrough that made it work
                {
                  name = "@vue/typescript-plugin",
                  location = vue_language_server_path,
                  languages = { "vue" },
                },
              },
            },
            settings = {
              typescript = {
                tsserver = { useSyntaxServer = false },
                inlayHints = {
                  includeInlayParameterNameHints = 'all',
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
            },
          })
        end,
        ["volar"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.volar.setup({
            --on_attach = function(client)
            --  client.server_capabilities.documentFormattingProvider = false
            --  client.server_capabilities.documentRangeFormattingProvider = false
            --end,
            --init_options = {
            --  vue = {
            --    hybridMode = false,
            --  },
            --},
            settings = {
              typescript = {
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  propertyDeclarationTypes = { enabled = true },
                  parameterTypes = {
                    enabled = true,
                    suppressWhenArgumentMatchesName = true,
                  },
                  variableTypes = { enabled = true },
                },
              },
            },
          })
        end,
        ["yamlls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.yamlls.setup({
            on_attach = function(client, bufnr)
              client.server_capabilities.documentFormattingProvider = true
            end,
            settings = {
              yaml = {
                keyOrdering = false,
              },
            },
          })
        end,
      }
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<Enter>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),

        -- scroll up and down the documentation window
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      })
    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      virtual_text = true,
      signs = true,
      underline = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })

    vim.api.nvim_set_keymap("n", "<leader>x", "", {
      noremap = true,
      callback = function()
        for _, client in ipairs(vim.lsp.get_clients()) do
          require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
        end
      end,
    })

    vim.api.nvim_create_autocmd('LspAttach', {
      --group = ThePrimeagenGroup,
      callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
      end
    })
  end
}
