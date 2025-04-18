local prefix = "<LocalLeader>R"

local scratch = { function() require("kulala").scratchpad() end, desc = "Open scratchpad" }
local env = { function() require("kulala").get_selected_env() end, desc = "Select env" }
local insepect = { function() require("kulala").inspect() end, desc = "Inspect current request" }
local open = { function() require "kulala".open() end, desc = "Open Kulala" }
local next = { function() require "kulala".jump_next() end, desc = "Jump to next request" }
local prev = { function() require "kulala".jump_prev() end, desc = "Jump to prev request" }
local run_all = { function() require "kulala".run_all() end, desc = "Send all request" }
local run = { function() require "kulala".run() end, desc = "Send request" }
local replay = { function() require "kulala".replay() end, desc = "Replay the last request" }
local show_header = { function() require "kulala".show_headers() end, desc = "Show headers" }
return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  opts = {
    -- cURL path
    -- if you have curl installed in a non-standard path,
    -- you can specify it here
    curl_path = "curl",
    -- additional cURL options
    -- see: https://curl.se/docs/manpage.html
    additional_curl_options = {},
    -- gRPCurl path, get from https://github.com/fullstorydev/grpcurl.git
    grpcurl_path = "grpcurl",
    -- websocat path, get from https://github.com/vi/websocat.git
    websocat_path = "websocat",
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        opts.mappings.n[prefix] = { desc = "󰖟 Kulala http" }
        opts.mappings.n[prefix .. "s"] = run
        opts.mappings.n[prefix .. "a"] = run_all
        opts.mappings.n[prefix .. "r"] = replay
        opts.mappings.n[prefix .. "H"] = show_header
        opts.mappings.n[prefix .. "j"] = next
        opts.mappings.n[prefix .. "k"] = prev
        opts.mappings.n[prefix .. "i"] = insepect
        opts.mappings.n[prefix .. "e"] = env
        opts.mappings.n[prefix .. "o"] = open
        opts.mappings.n[prefix .. "b"] = scratch

        opts.mappings.v[prefix .. "s"] = run
      end
    }
  },
}
