-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Set up custom filetypes
-- vim.filetype.add {
--   extension = {
--     foo = "fooscript",
--   },
--   filename = {
--     ["Foofile"] = "fooscript",
--   },
--   pattern = {
--     ["~/%.config/foo/.*"] = "fooscript",
--   },
-- }

local create_command = vim.api.nvim_create_user_command

create_command("Json", function() vim.bo.filetype = "json" end, { desc = "json filetype" })
create_command("SqlType", function() vim.bo.filetype = "sql" end, { desc = "sql filetype" })
create_command(
  "Ld",
  function() require("resession").load(vim.fn.getcwd(), { dir = "dirsession" }) end,
  { desc = "load current dir session" }
)
create_command("DI", function() vim.cmd "DBUI" end, { desc = "DBUI" })

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "json",
--   callback = function(ev) vim.bo[ev.buf].formatprg = "jq" end,
-- })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "http",
  callback = function(ev)
    local utils = require "astrocore"
    -- maps.n["<leader>r"]
    local prefix = "<Leader>r"
    utils.set_mappings({
      n = {
        [prefix] = { desc = require("astroui").get_icon("RestNvim", 1, true) .. "RestNvim" },
        [prefix .. "r"] = { "<cmd>Rest run<cr>", desc = "Run request under the cursor" },
        [prefix .. "l"] = { "<cmd>Rest run last<cr>", desc = "Re-run latest request" },
        [prefix .. "e"] = { "<cmd>Telescope rest select_env<cr>", desc = "Select environment variables file" },
      },
    }, { buffer = ev.buf })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java,go,rust",
  callback = function(ev)
    local utils = require "astrocore"
    utils.set_mappings({
      n = {
        ["<leader>rr"] = nil,
        ["<leader>rl"] = nil,
        ["<leader>re"] = nil,
        ["<Leader>r"] = { '<cmd>lua require"quickrun".run_command()<cr>', desc = "QuickRun" },
      },
    }, { buffer = ev.buf })
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function(ev) vim.bo[ev.buf].shiftwidth = 2 end,
})
