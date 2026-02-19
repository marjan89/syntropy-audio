-- Audio device management module
-- Handles listing and switching audio devices via SwitchAudioSource

local M = {}

-- String utility functions
local string_utils = {}

-- Check if string starts with prefix
function string_utils.starts_with(s, prefix)
	return s:sub(1, #prefix) == prefix
end

-- Check if SwitchAudioSource is installed
function M.check_dependencies()
    local _, code = syntropy.shell("command -v SwitchAudioSource >/dev/null 2>&1")
    if code ~= 0 then
        return false, "SwitchAudioSource not found. Install with: brew install switchaudio-osx"
    end
    return true, nil
end

-- Get the current audio device
-- @param device_type string: "output" or "input"
-- @return string: current device name, or nil on error
function M.get_current_device(device_type)
    local output, code = syntropy.shell(string.format("SwitchAudioSource -c -t %s 2>&1", device_type))

    if code ~= 0 then
        return nil
    end

    -- Trim whitespace
    local current = output:gsub("^%s*(.-)%s*$", "%1")
    return current
end

-- List all audio devices with indicators
-- @param device_type string: "output" or "input"
-- @param selected_icon string: icon for selected device (default: "◍")
-- @param unselected_icon string: icon for unselected device (default: "○")
-- @return table: array of device strings with indicators, or error message
function M.list_devices(device_type, selected_icon, unselected_icon)
    -- Default icons if not provided
    selected_icon = selected_icon or "◍"
    unselected_icon = unselected_icon or "○"

    -- Check dependencies first
    local ok, err = M.check_dependencies()
    if not ok then
        return {err}
    end

    -- Get current device
    local current = M.get_current_device(device_type)

    -- Get all devices
    local output, code = syntropy.shell(string.format("SwitchAudioSource -a -t %s 2>&1", device_type))

    if code ~= 0 then
        return {string.format("Error listing %s devices: %s", device_type, output)}
    end

    if output == "" then
        return {string.format("No %s devices found", device_type)}
    end

    -- Parse devices and add indicators
    local devices = {}
    for line in output:gmatch("[^\r\n]+") do
        local device = line:gsub("^%s*(.-)%s*$", "%1")  -- Trim whitespace

        if device ~= "" then
            -- Mark current device with selected icon, others with unselected icon
            local indicator = (device == current) and (selected_icon .. " ") or (unselected_icon .. " ")
            table.insert(devices, indicator .. device)
        end
    end

    if #devices == 0 then
        return {string.format("No %s devices found", device_type)}
    end

    return devices
end

-- Switch to a specific audio device
-- @param device string: device name (may include indicator prefix)
-- @param device_type string: "output" or "input"
-- @return string, number: message, exit_code
function M.switch_device(device, device_type)
    if not device or device == "" then
        return string.format("Error: No %s device specified", device_type), 1
    end

    -- Remove indicator prefix if present (any single character/emoji + space)
    -- This handles any icon configuration
    local clean_device = device:gsub("^. ", "")

    -- Execute switch command
    local output, code = syntropy.shell(
        string.format("SwitchAudioSource -s '%s' -t %s 2>&1", clean_device, device_type)
    )

    if code ~= 0 then
        return string.format("Error switching to %s: %s", clean_device, output), 1
    end

    return string.format("Switched %s to: %s", device_type, clean_device), 0
end

return M
