return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- LSP Support
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Autocompletion
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
    "artemave/workspace-diagnostics.nvim",
    "onsails/lspkind.nvim",
    --{ "rafamadriz/friendly-snippets" },
  },

  config = function()

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim", "it", "describe", "before_each", "after_each" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    })

    vim.lsp.config('volar', {
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

    vim.lsp.config('ts_ls', {
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      init_options = {
        plugins = { -- I think this was my breakthrough that made it work
          {
            name = "@vue/typescript-plugin",
            location = vim.fn.exepath("vue-language-server"),
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

    vim.lsp.config('csharp_ls', {})
    local orig_handler = vim.lsp.handlers["window/showMessage"]
    vim.lsp.handlers["window/showMessage"] = function(err, params, ctx, config)
      local client = vim.lsp.get_client_by_id(ctx.client_id) or {}

      if client.name == "csharp_ls" and params.type == 3 then
        return
      end

      return orig_handler(err, params, ctx, config)
    end

    vim.lsp.config('yamlls', {
      on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = true
      end,
      settings = {
        yaml = {
          keyOrdering = false,
        },
      },
    })

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
      automatic_enable = true,
    })

    local cmp = require('cmp')
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
      }),
      view = {
        entries = { name = "custom", selection_order = "near_cursor" },
      },

      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          if vim.tbl_contains({ "path" }, entry.source.name) then
            local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
            if icon then
              vim_item.kind = icon
              vim_item.kind_hl_group = hl_group
              return vim_item
            end
          end
          local kind = require("lspkind").cmp_format({ with_text = true })(entry, vim_item)
          local strings = vim.split(kind.kind, "%s", { trimempty = true })
          kind.kind = " " .. (strings[1] or "") .. " "
          kind.menu = "    (" .. (strings[2] or "") .. ")"
          return kind
        end,
      },
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
        source = true,
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
        --vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        --vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
      end
    })
  end
}
