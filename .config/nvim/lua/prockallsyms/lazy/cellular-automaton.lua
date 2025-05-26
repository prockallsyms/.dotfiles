return {
	'Eandrju/cellular-automaton.nvim',
	-- shamefully ripped from tamton-aquib/zone.nvim
	config = function(opts)
		local timer
		local grp = vim.api.nvim_create_augroup('CellularAutomaton', {clear = true})
		vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
			group = grp,
			callback = function()
				if vim.g.cellular_automaton then
					vim.notify("[cellular_automaton.lua]: CellularAutomaton is already running!")
					return
				end

				timer = vim.loop.new_timer()
				-- adjust the delay as needed here
				timer:start(30 * 1000, 0, vim.schedule_wrap(function()
					if timer:is_active() then timer:stop() end
					if opts.style == "customcmd" then
						vim.cmd(opts.customcmd)
					else
						vim.g.cellular_automaton = true
						vim.notify("[cellular_automaton.lua]: Press q or <Esc> to stop the Cellular Automaton.")
						vim.cmd("CellularAutomaton " .. (opts.style or "game_of_life")) -- any style listed on Eandrju/cellular-automaton.nvim will work
					end
				end))

				vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
					group = grp,
					callback = function()
						if timer:is_active() then timer:stop() end
						if not timer:is_closing() then timer:close() end
						vim.g.cellular_automaton = false
					end,
					once = true
				})
			end,
		})
	end
}
