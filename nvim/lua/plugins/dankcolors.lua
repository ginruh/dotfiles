return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#191114',
				base01 = '#191114',
				base02 = '#a5999e',
				base03 = '#a5999e',
				base04 = '#ffeff6',
				base05 = '#fff8fb',
				base06 = '#fff8fb',
				base07 = '#fff8fb',
				base08 = '#ff9fa4',
				base09 = '#ff9fa4',
				base0A = '#ffbbd7',
				base0B = '#bcffa5',
				base0C = '#ffdbea',
				base0D = '#ffbbd7',
				base0E = '#ffc7de',
				base0F = '#ffc7de',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#a5999e',
				fg = '#fff8fb',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#ffbbd7',
				fg = '#191114',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#a5999e' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffdbea', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#ffc7de',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#ffbbd7',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#ffbbd7',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#ffdbea',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#bcffa5',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#ffeff6' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#ffeff6' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#a5999e',
				italic = true
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
