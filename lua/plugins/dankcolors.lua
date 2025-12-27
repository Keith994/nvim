return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#091518',
				base01 = '#162125',
				base02 = '#2b373a',
				base03 = '#3d494c',
				base04 = '#bcc9cd',
				base05 = '#d8e5e9',
				base06 = '#d8e5e9',
				base07 = '#273236',
				base08 = '#ffb4ab',
				base09 = '#a5caf5',
				base0A = '#bcc9cd',
				base0B = '#00d9fd',
				base0C = '#a8cbe2',
				base0D = '#00d9fd',
				base0E = '#a8cbe2',
				base0F = '#ffb4ab',
			})

			local function set_hl_mutliple(groups, value)
				for _, v in pairs(groups) do vim.api.nvim_set_hl(0, v, value) end
			end

			vim.api.nvim_set_hl(0, 'Visual',
				{ bg = '#004e5c', fg = '#acedff', bold = true })
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#3d494c' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#00d9fd', bold = true })

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"

			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()

				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)

					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("󰂖 Matugen: Colors reloaded!")
					end
				end))
			end
		end
	}
}
