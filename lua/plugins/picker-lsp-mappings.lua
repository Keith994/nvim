return {
  "AstroNvim/astrolsp",
  ---@param opts AstroLSPOpts
  opts = function(_, opts)
    if opts.mappings.n.gd then opts.mappings.n.gd[1] = function() require("snacks.picker").lsp_definitions() end end
    if opts.mappings.n.gI then opts.mappings.n.gI[1] = function() require("snacks.picker").lsp_implementations() end end
    if opts.mappings.n.gD then
      opts.mappings.n.gD[1] = function() require("snacks.picker").lsp_type_definitions() end
    end
    if opts.mappings.n["<Leader>lG"] then
      opts.mappings.n["<Leader>lG"][1] = function() require("snacks.picker").lsp_workspace_symbols() end
    end
    if opts.mappings.n["<Leader>lr"] then
      opts.mappings.n["<Leader>lr"][1] = function() require("snacks.picker").lsp_references() end
    end
    if opts.mappings.n["<Leader>lR"] then opts.mappings.n["<Leader>lR"][1] = function() vim.lsp.buf.rename() end end
  end,
}
