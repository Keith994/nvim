return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#1a1018',
				base01 = '#5c6370',
				base02 = '#aa6096',
				base03 = '#bf8cb8',
				base04 = '#abb2bf',
				base05 = '#ffbefa',
				base06 = '#ffaaf4',
				base07 = '#ffffff',

				base08 = '#c856b8',
				base09 = '#d3db7b',
				base0A = '#e1e897',
				base0B = '#6ed67f',
				base0C = '#86e094',
				base0D = '#e0775f',
				base0E = '#d8593c',
				base0F = '#b056b3',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#aa6096',
				fg = '#ffffff',
				bold = true
			})

			vim.api.nvim_set_hl(0, 'LineNr', {
				fg = '#5c6370'
			})

			vim.api.nvim_set_hl(0, 'CursorLineNr', {
				fg = '#ffaaf4',
				bold = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"

			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()

				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)

					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
