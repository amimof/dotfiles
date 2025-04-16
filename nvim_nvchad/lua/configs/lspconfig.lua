local configs = require("nvchad.configs.lspconfig")
-- local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")
local util = require("lspconfig/util")
local servers = { "html", "gopls", "yamlls", "lua_ls", "marksman", "ts_ls", "buf_ls" }

local on_attach = function(client, bufnr)
  require("nvchad.lsp.signature").setup(client, bufnr)
end

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  })
end

-- YAML
lspconfig.yamlls.setup({
  on_attach = function(client)
    if vim.fn.has("nvim-0.10") == 0 then
      if client.name == "yamlls" then
        client.server_capabilities.documentFormattingProvider = true
      end
    end
  end,
  capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },
  -- lazy-load schemastore when needed
  on_new_config = function(new_config)
    new_config.settings.yaml.schemas =
        vim.tbl_deep_extend("force", new_config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
  end,
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      keyOrdering = false,
      format = {
        enable = true,
      },
      validate = true,
      schemas = {
        kubernetes = "k8s-*.yaml",
        ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
        ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
        ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/**/*.{yml,yaml}",
        ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
        ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
        ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
        ["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
      },
      -- schemaStore = {
      --   -- Must disable built-in schemaStore support to use
      --   -- schemas from SchemaStore.nvim plugin
      --   enable = false,
      --   -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
      --   url = "",
      -- },
      -- schemas = {
      --   ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] =
      --   "/*.k8s.yaml",
      -- }
      -- schemas = require('schemastore').yaml.schemas({
      --   extra = {
      --     description = "Test",
      --     name = "test.json",
      --     url =
      --     "https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"
      --   }
      -- }),
    },
  },
})

-- Go
lspconfig.gopls.setup({
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      gofumpt = true,
      completeUnimported = true,
      usePlaceholders = false,
      analyses = {
        unusedParams = true,
      },
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      linksInHover = true,
      linkTarget = "pkg.go.dev",
      staticcheck = true,
    },
  },
})

-- Protocol buffers
lspconfig.buf_ls.setup({
  cmd = { "buf", "beta", "lsp" },
  filetypes = { "proto" },
  root_dir = lspconfig.util.root_pattern("buf.yaml", ".git"),
  settings = {},
})

-- Lua
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          "vim",
          "require",
        },
      },
      workspace = {
        checkThirdParty = false,
      },
      codeLens = {
        enable = true,
      },
      completion = {
        callSnippet = "Replace",
      },
      doc = {
        privateName = { "^_" },
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
    },
  },
})

-- Markdown
lspconfig.marksman.setup({})

-- Vue
local mason_registry = require("mason-registry")
local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
    .. "/node_modules/@vue/language-server"
lspconfig.ts_ls.setup({
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
})
lspconfig.volar.setup({})
