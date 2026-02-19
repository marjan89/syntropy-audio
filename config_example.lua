-- Configuration example for syntropy-audio plugin
--
-- This file shows how to override the default audio plugin settings.
--
-- To use this configuration:
-- 1. Create the directory: ~/.config/syntropy/plugins/syntropy-audio/
-- 2. Copy this file to: ~/.config/syntropy/plugins/syntropy-audio/plugin.lua
-- 3. Modify the config values as desired
--
-- The configuration will be automatically loaded when the plugin starts.

---@type PluginOverride
return {
	metadata = {
		name = "audio",  -- Must match the plugin name
		version = "1.0.0",
	},

	config = {
		-- Icons used to indicate device status
		-- Default values use standard Unicode circles:
		selected_icon = "◍",    -- Icon for currently selected device
		unselected_icon = "○",  -- Icon for unselected devices

		-- Example: Use Nerd Font icons (requires a Nerd Font to be installed)
		-- selected_icon = "󰕾",   -- Nerd Font speaker on icon
		-- unselected_icon = "󰖁", -- Nerd Font speaker off icon

		-- Example: Use emoji
		-- selected_icon = "✓",
		-- unselected_icon = "○",

		-- Example: Use simple ASCII
		-- selected_icon = "*",
		-- unselected_icon = "-",
	},
}
