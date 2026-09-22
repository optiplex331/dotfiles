if vim.fn.has("mac") == 1 then
  return {
    "keaising/im-select.nvim",
    config = function()
      require("im_select").setup({
        default_command = "macism",
        keep_quiet_on_no_binary = true,
      })
    end,
  }
else
  return {}
end
