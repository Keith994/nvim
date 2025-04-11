vim.api.nvim_create_autocmd("FileType", {
  pattern = "java,go,rust",
  callback = function(ev)
    local utils = require "astrocore"
    utils.set_mappings({
      n = {
        ["<Leader>r"] = { '<cmd>lua require"quickrun".run_command()<cr>', desc = "QuickRun" },
      },
    }, { buffer = ev.buf })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function(ev) vim.bo[ev.buf].shiftwidth = 2 end,
})
