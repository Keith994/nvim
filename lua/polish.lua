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

create_command(
  "Ld",
  function() require("resession").load(vim.fn.getcwd(), { dir = "dirsession" }) end,
  { desc = "load current dir session" }
)
create_command("DI", function() vim.cmd "DBUI" end, { desc = "DBUI" })
create_command("DapUIOpen", function()
  local dapui = require "dapui"
  dapui.open { layout = 1 }
  dapui.open { layout = 3 }
end, { desc = "DapUI Open" })
create_command("DapUIClose", function() require("dapui").close() end, { desc = "DapUI Close" })
create_command(
  "DapConsole",
  function()
    require("dapui").toggle {
      layout = 4,
    }
  end,
  { desc = "DapUI Console Toggle" }
)
create_command(
  "DapConsoleBtm",
  function()
    require("dapui").toggle {
      layout = 3,
    }
  end,
  { desc = "DapUI Console Toggle" }
)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function(ev) vim.bo[ev.buf].formatprg = "jq" end,
})

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
  pattern = "java,go",
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
