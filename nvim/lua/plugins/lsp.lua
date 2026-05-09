-- LSP keymaps
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        biome = {},
        ruff = {},
        ["*"] = {
          inlay_hints = {
            enabled = true,
          },
          ["rust_analyzer"] = {
            settings = { allFeatures = true },
          },
          keys = {
            { "K", false },
          },
        },
      },
    },
  },
}
