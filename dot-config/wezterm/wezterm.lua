local wezterm = require 'wezterm' ---@type Wezterm
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder() ---@type Config
local open_sessionizer = require 'actions.open_sessionizer'
local workspaces = require 'actions.workspaces'
-- local wez_tmux = require 'plugins.wez-tmux.plugin'

config.mux_enable_ssh_agent = true
config.default_ssh_auth_sock = wezterm.home_dir .. '/.var/app/com.bitwarden.desktop/.bitwarden-ssh-agent.sock'
config.default_workspace = 'default'

-- Your settings go here
config.font = wezterm.font {
	family = 'JetBrains Mono',
	harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
}
config.color_scheme = 'BlulocoDark'
config.font_size = 14.0
config.tab_bar_at_bottom = true
config.window_decorations = "NONE"
config.window_padding = {
	bottom = 0,
	left = 0,
	right = 0,
	top = 0,
}

local ActionRenameWorkspace = wezterm.action_callback(function(window, pane)
	window:perform_action(act.PromptInputLine({
		description = "Rename workspace: ",
		action = wezterm.action_callback(function(_, _, line)
			if not line or line == "" then
				return
			end

			mux.rename_workspace(mux.get_active_workspace(), line)
		end),
	}), pane)
end)


wezterm.on('update-right-status', function(window, pane)
	local name = window:active_workspace()
	if window:leader_is_active() then
		name = "LEADER | " .. name
	end
	window:set_right_status(wezterm.format {
		{ Text = name },
	})
end)

config.leader = { key = 'Space', mods = 'CTRL' }
-- wez_tmux.apply_to_config(config, {})

config.keys = config.keys or {}

local custom_keys = {
	{ key = 'h', mods = 'CTRL|SHIFT',   action = act.ActivatePaneDirection 'Left' },
	{ key = 'j', mods = 'CTRL|SHIFT',   action = act.ActivatePaneDirection 'Down' },
	{ key = 'k', mods = 'CTRL|SHIFT',   action = act.ActivatePaneDirection 'Up' },
	{ key = 'l', mods = 'CTRL|SHIFT',   action = act.ActivatePaneDirection 'Right' },
	-- TMUX
	{ key = "c", mods = "LEADER",       action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "&", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "p", mods = "LEADER",       action = act.ActivateTabRelative(-1) },
	{ key = "n", mods = "LEADER",       action = act.ActivateTabRelative(1) },
	{ key = "l", mods = "LEADER",       action = act.ActivateLastTab },
	{ key = ",", mods = "LEADER",       action = ActionRenameWorkspace },

	{ key = "[", mods = "LEADER",       action = act.ActivateCopyMode },
	{
		key = "%",
		mods = "LEADER|SHIFT",
		action = act.SplitHorizontal({
			domain = "CurrentPaneDomain" })
	},
	{
		key = "\"",
		mods = "LEADER|SHIFT",
		action = act.SplitVertical({
			domain = "CurrentPaneDomain" })
	},


	{
		key = 'h',
		mods = 'LEADER',
		action = wezterm.action_callback(function(window, pane)
			workspaces.switch_workspace(window, pane, {
				name = 'default',
				spawn = {
					cwd = wezterm.home_dir,
				},
			})
		end),
	},
	{
		key = 'd',
		mods = 'LEADER',
		action = act.DetachDomain 'CurrentPaneDomain',
	},
	{
		key = '.',
		mods = 'CTRL|LEADER',
		action = wezterm.action_callback(function(window, pane)
			workspaces.switch_workspace(window, pane, {
				name = 'dotfiles',
				spawn = {
					cwd = wezterm.home_dir .. '/.dotfiles',
					args = { 'nvim', './dot-config/wezterm/wezterm.lua' },
				},
			})
		end),
	},
	{
		key = 's',
		mods = 'LEADER',
		action = workspaces.workspace_switcher_action(),
	},
	{
		key = 'f',
		mods = 'LEADER',
		action = open_sessionizer.action
	},
	{
		key = 'w',
		mods = 'LEADER',
		action = act.PromptInputLine {
			description = 'Name for new workspace:',
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					workspaces.switch_workspace(
						window,
						pane,
						{
							name = line,
							spawn = { cwd = pane:get_current_working_dir() },
						}
					)
				end
			end),
		},
	},
	{
		key = 'L',
		mods = 'LEADER|SHIFT',
		action = wezterm.action_callback(function(window, pane)
			workspaces.switch_to_previous_workspace(window, pane)
		end),
	},
	{
		key = 'm',
		mods = 'LEADER',
		action = wezterm.action_callback(function(window, pane)
			workspaces.switch_workspace(window, pane, {
				name = 'monitoring',
				spawn = {
					args = { 'btop' },
				},
			})
		end),
	},
}

for _, key in ipairs(custom_keys) do
	table.insert(config.keys, key)
end

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = 'CTRL',
		action = act.ActivateTab(i - 1),
	})
end

table.insert(config.keys, {
	key = '0',
	mods = 'CTRL',
	action = act.ActivateTab(-1),
})

return config
