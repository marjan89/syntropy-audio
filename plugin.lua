-- Audio device switcher plugin
-- Provides tasks for switching audio output and input devices
-- Emulates the functionality of audio_switcher.sh

local devices = require("audio.devices")

-- Default configuration
local default_config = {
	selected_icon = "◍",  -- Unicode filled circle for selected device
	unselected_icon = "○",  -- Unicode empty circle for unselected device
}

-- Get configuration with fallback to defaults
local function get_config()
	local plugin = audio  -- Plugin is stored in globals with its name
	return plugin and plugin.config or default_config
end

-- Get icon configuration
local function get_icons()
	local config = get_config()
	return config.selected_icon, config.unselected_icon
end

---@type PluginDefinition
return {
    metadata = {
        name = "audio",
        version = "1.0.0",
        icon = "󰕾",
        description = "Switch audio input and output devices",
        platforms = { "macos" },
    },

    tasks = {
        -- Output device switching (speakers, headphones, etc.)
        output = {
            name = "Switch Output Device",
            description = "Switch audio output device (speakers, headphones)",
            mode = "none",
            exit_on_execute = true,

            item_sources = {
                devices = {
                    tag = "output",

                    items = function()
                        local selected_icon, unselected_icon = get_icons()
                        return devices.list_devices("output", selected_icon, unselected_icon)
                    end,

                    preview = function(item)
                        local selected_icon, unselected_icon = get_icons()
                        -- Escape special characters in icons for pattern matching
                        local selected_escaped = selected_icon:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
                        local unselected_escaped = unselected_icon:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")

                        local device = item:gsub("^[" .. selected_escaped .. unselected_escaped .. "] ", "")
                        local is_current = item:match("^" .. selected_escaped .. " ") ~= nil

                        if is_current then
                            return string.format("Current output device:\n%s\n\n%s Active", device, selected_icon)
                        else
                            return string.format("Output device:\n%s\n\n%s Not active", device, unselected_icon)
                        end
                    end,

                    execute = function(items)
                        if not items or #items == 0 then
                            return "Error: No output device selected", 1
                        end

                        return devices.switch_device(items[1], "output")
                    end,
                },
            },
        },

        -- Input device switching (microphones, etc.)
        input = {
            name = "Switch Input Device",
            description = "Switch audio input device (microphones)",
            mode = "none",
            exit_on_execute = true,

            item_sources = {
                devices = {
                    tag = "input",

                    items = function()
                        local selected_icon, unselected_icon = get_icons()
                        return devices.list_devices("input", selected_icon, unselected_icon)
                    end,

                    preview = function(item)
                        local selected_icon, unselected_icon = get_icons()
                        -- Escape special characters in icons for pattern matching
                        local selected_escaped = selected_icon:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
                        local unselected_escaped = unselected_icon:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")

                        local device = item:gsub("^[" .. selected_escaped .. unselected_escaped .. "] ", "")
                        local is_current = item:match("^" .. selected_escaped .. " ") ~= nil

                        if is_current then
                            return string.format("Current input device:\n%s\n\n%s Active", device, selected_icon)
                        else
                            return string.format("Input device:\n%s\n\n%s Not active", device, unselected_icon)
                        end
                    end,

                    execute = function(items)
                        if not items or #items == 0 then
                            return "Error: No input device selected", 1
                        end

                        return devices.switch_device(items[1], "input")
                    end,
                },
            },
        },
    },
}
