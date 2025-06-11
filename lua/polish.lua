local create_command = vim.api.nvim_create_user_command

create_command("JavaTestNearestMethod",
  function() require("jdtls.dap").test_nearest_method() end,
  { desc = "Test Debug" })

create_command("Json", function() vim.bo.filetype = "json" end, { desc = "json filetype" })
create_command("SqlType", function() vim.bo.filetype = "sql" end, { desc = "sql filetype" })
create_command("XmlType", function() vim.bo.filetype = "xml" end, { desc = "xml filetype" })
create_command("Ld",
  function() require("resession").load(vim.fn.getcwd(), { dir = "dirsession" }) end,
  { desc = "load current dir session" }
)
create_command("DI", function() vim.cmd "DBUI" end, { desc = "DBUI" })

require "autocmds"
