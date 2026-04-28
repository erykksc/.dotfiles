local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

local M = {}

local function shell_quote(value)
	return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function basename(path)
	return path:match('([^/]+)/*$') or path
end

local function has_workspace(name)
	for _, workspace in ipairs(mux.get_workspace_names()) do
		if workspace == name then
			return true
		end
	end

	return false
end

function M.notify(window, message)
	window:toast_notification('WezTerm', message, nil, 4000)
end

function M.remember_previous_workspace(window, target_workspace)
	local current_workspace = window:active_workspace()
	if current_workspace == target_workspace then
		return false
	end

	wezterm.GLOBAL.previous_workspace = current_workspace
	return true
end

function M.clear_previous_workspace_if(name)
	if wezterm.GLOBAL.previous_workspace == name then
		wezterm.GLOBAL.previous_workspace = nil
	end
end

function M.switch_workspace(window, pane, workspace)
	if not workspace or not workspace.name then
		return
	end

	if not M.remember_previous_workspace(window, workspace.name) then
		return
	end

	window:perform_action(act.SwitchToWorkspace(workspace), pane)
end

function M.switch_to_previous_workspace(window, pane)
	local current_workspace = window:active_workspace()
	local previous_workspace = wezterm.GLOBAL.previous_workspace

	if not previous_workspace then
		M.notify(window, 'No previous workspace')
		return
	end

	if previous_workspace == current_workspace then
		return
	end

	if not has_workspace(previous_workspace) then
		wezterm.GLOBAL.previous_workspace = nil
		M.notify(window, 'Previous workspace is no longer available')
		return
	end

	M.switch_workspace(window, pane, { name = previous_workspace })
end

local function get_sessionizer_roots()
	return {
		wezterm.home_dir,
		wezterm.home_dir .. '/dev',
		wezterm.home_dir .. '/Documents',
		wezterm.home_dir .. '/Documents/TU-Berlin/Master-semester-1',
	}
end

function M.workspace_name_from_path(path)
	return basename(path):gsub('%.', '_')
end

function M.get_sessionizer_choices()
	local parts = {}
	for _, root in ipairs(get_sessionizer_roots()) do
		table.insert(parts, 'find -L ' .. shell_quote(root) .. ' -mindepth 1 -maxdepth 1 -type d 2>/dev/null')
	end

	local handle = io.popen(table.concat(parts, '; '))
	if not handle then
		return {}
	end

	local choices = {}
	local seen = {}
	for path in handle:lines() do
		if not seen[path] then
			seen[path] = true
			table.insert(choices, {
				id = path,
				label = path,
			})
		end
	end
	handle:close()

	table.sort(choices, function(left, right)
		return left.label < right.label
	end)

	return choices
end

function M.open_project_picker_action()
	return wezterm.action_callback(function(window, pane)
		local choices = M.get_sessionizer_choices()
		if #choices == 0 then
			wezterm.log_warn 'OpenSessionizer: no project directories found'
			return
		end

		window:perform_action(act.InputSelector {
			title = 'Open session',
			choices = choices,
			fuzzy = true,
			fuzzy_description = 'Select a project directory: ',
			action = wezterm.action_callback(function(inner_window, inner_pane, id, _)
				if not id then
					return
				end

				M.open_workspace_layout(inner_window, inner_pane, M.workspace_name_from_path(id), id)
			end),
		}, pane)
	end)
end

function M.open_workspace_layout(window, pane, name, cwd)
	if has_workspace(name) then
		M.switch_workspace(window, pane, { name = name })
		return
	end

	M.remember_previous_workspace(window, name)

	local nvim_tab, _, mux_window = mux.spawn_window {
		workspace = name,
		cwd = cwd,
		args = { 'nvim' },
	}

	local zsh_tab = mux_window:spawn_tab {
		cwd = cwd,
		args = { 'zsh' },
	}

	local opencode_tab = mux_window:spawn_tab { cwd = cwd }
	opencode_tab:active_pane():send_text("opencode\r")

	nvim_tab:set_title 'nvim'
	zsh_tab:set_title 'zsh'
	opencode_tab:set_title 'opencode'
	nvim_tab:activate()
	M.switch_workspace(window, pane, { name = name })
end

function M.get_workspace_choices(active_workspace)
	local workspaces = mux.get_workspace_names()
	local num_tabs_by_workspace = {}
	local previous_workspace = wezterm.GLOBAL.previous_workspace
	local included = {}

	for _, mux_window in ipairs(mux.all_windows()) do
		local workspace = mux_window:get_workspace()
		local num_tabs = #mux_window:tabs()
		num_tabs_by_workspace[workspace] = (num_tabs_by_workspace[workspace] or 0) + num_tabs
	end

	table.sort(workspaces)

	local choices = {}
	local function add_choice(workspace)
		if not workspace or included[workspace] or not has_workspace(workspace) then
			return
		end

		included[workspace] = true
		local suffix = ''
		if workspace == active_workspace then
			suffix = ' (active)'
		end

		table.insert(choices, {
			id = workspace,
			label = string.format('%s: %d tabs%s', workspace, num_tabs_by_workspace[workspace] or 0, suffix),
		})
	end

	add_choice(previous_workspace)
	add_choice(active_workspace)

	for _, workspace in ipairs(workspaces) do
		add_choice(workspace)
	end

	return choices
end

function M.workspace_switcher_action()
	return wezterm.action_callback(function(window, pane)
		local active_workspace = window:active_workspace()
		local choices = M.get_workspace_choices(active_workspace)

		window:perform_action(act.InputSelector {
			title = 'Switch workspace',
			choices = choices,
			fuzzy = true,
			fuzzy_description = 'Select a workspace: ',
			action = wezterm.action_callback(function(inner_window, inner_pane, id, _)
				if not id then
					return
				end

				M.switch_workspace(inner_window, inner_pane, { name = id })
			end),
		}, pane)
	end)
end

return M
