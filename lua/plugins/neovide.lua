if not vim.g.neovide then return {} end

---@param scale_factor number
---@return number
local function clamp_scale_factor(scale_factor)
  return math.max(math.min(scale_factor, vim.g.neovide_max_scale_factor), vim.g.neovide_min_scale_factor)
end

---@param scale_factor number
---@param clamp? boolean
local function set_scale_factor(scale_factor, clamp)
  vim.g.neovide_scale_factor = clamp and clamp_scale_factor(scale_factor) or scale_factor
end

local function reset_scale_factor() vim.g.neovide_scale_factor = vim.g.neovide_initial_scale_factor end

---@param increment number
---@param clamp? boolean
local function change_scale_factor(increment, clamp) set_scale_factor(vim.g.neovide_scale_factor + increment, clamp) end

return {
  "AstroNvim/astrocore",
  opts = {
    options = {
      g = {
        neovide_increment_scale_factor = vim.g.neovide_increment_scale_factor or 0.1,
        neovide_min_scale_factor = vim.g.neovide_min_scale_factor or 0.5,
        neovide_max_scale_factor = vim.g.neovide_max_scale_factor or 2.0,
        neovide_initial_scale_factor = vim.g.neovide_scale_factor or 0.6,
        neovide_scale_factor = vim.g.neovide_scale_factor or 0.6,
        -- neovide_text_gamma = 0.1,
        -- neovide_text_contrast = 0.5,
        neovide_confirm_quit = true,
        neovide_input_ime = true,
      },
      opt = {
        guifont = "LigaSFMonoNerdFont-Regular:h10",
      }
    },
    commands = {
      NeovideSetScaleFactor = {
        function(event)
          local scale_factor, option = tonumber(event.fargs[1]), event.fargs[2]

          if not scale_factor then
            vim.notify(
              "Error: scale factor argument is nil or not a valid number.",
              vim.log.levels.ERROR,
              { title = "Recipe: neovide" }
            )
            return
          end

          set_scale_factor(scale_factor, option ~= "force")
        end,
        nargs = "+",
        desc = "Set Neovide scale factor",
      },
      NeovideResetScaleFactor = {
        reset_scale_factor,
        desc = "Reset Neovide scale factor",
      },
    },
    mappings = {
      n = {
        ["<C-+"] = {
          function() change_scale_factor(vim.g.neovide_increment_scale_factor * vim.v.count1, true) end,
          desc = "Increase Neovide scale factor",
        },
        ["<C--"] = {
          function() change_scale_factor(-vim.g.neovide_increment_scale_factor * vim.v.count1, true) end,
          desc = "Decrease Neovide scale factor",
        },
        ["<C-0>"] = { reset_scale_factor, desc = "Reset Neovide scale factor" },
      },
    },
  },
}
