# Audio Plugin

Switch audio input and output devices on macOS. Quickly change between speakers, headphones, and other output devices, or select different microphones for input through a fuzzy-searchable interface.

## Features

- **Output Device Switching**: Switch between speakers, headphones, and other audio output devices
- **Input Device Switching**: Switch between microphones and other audio input devices
- **Current Device Indicator**: Visual indicators show which device is currently active (◍) vs. inactive (○)
- **Fuzzy Search**: Quickly find devices by typing part of their name
- **Customizable Icons**: Configure your preferred icons (Unicode, Nerd Fonts, emoji, or ASCII)

## Installation

Add to your Syntropy configuration:

```toml
[plugins.audio]
git = "https://github.com/marjan89/audio.git"
tag = "v1.0.0"
```

## Tasks

### `output`

Switch audio output device (speakers, headphones, etc.)

Lists all available output devices with visual indicators showing the currently active device. Select a device to switch to it immediately.

### `input`

Switch audio input device (microphones, etc.)

Lists all available input devices with visual indicators showing the currently active device. Select a device to switch to it immediately.

## Requirements

- **Platform**: macOS only
- **Dependencies**: SwitchAudioSource (from `switchaudio-osx` package)

  Install with Homebrew:

  ```bash
  brew install switchaudio-osx
  ```

The plugin will automatically check for the dependency and show an error message if it's not installed.

## Configuration

The plugin uses standard Unicode icons by default (◍ for selected, ○ for unselected). You can customize these icons by creating a configuration override.

**To customize icons:**

1. Create the configuration directory:

   ```bash
   mkdir -p ~/.config/syntropy/plugins/audio
   ```

2. Copy the example configuration:

   ```bash
   cp ~/.local/share/syntropy/plugins/audio/config_example.lua \
      ~/.config/syntropy/plugins/audio/plugin.lua
   ```

3. Edit `~/.config/syntropy/plugins/audio/plugin.lua` and modify the icon settings:
   ```lua
   config = {
       selected_icon = "◍",    -- Icon for currently selected device
       unselected_icon = "○",  -- Icon for unselected devices
   }
   ```

**Icon options:**

- **Unicode** (default): `◍` and `○`
- **Nerd Fonts**: `󰕾` and `󰖁` (requires a Nerd Font installed)
- **Emoji**: `✓` and `○`
- **ASCII**: `*` and `-`

See `config_example.lua` for more examples.

## Usage

### Switch Output Device

```bash
syntropy audio output
```

This opens a searchable list of all output devices. The current device is marked with ◍, while inactive devices are marked with ○.

### Switch Input Device

```bash
syntropy audio input
```

This opens a searchable list of all input devices. The current device is marked with ◍, while inactive devices are marked with ○.

## Examples

**Switching to headphones:**

```bash
syntropy audio output
# Search for "headphones" and select
```

**Switching to an external microphone:**

```bash
syntropy audio input
# Search for "blue yeti" or device name and select
```

## Technical Details

The plugin uses the `SwitchAudioSource` command-line tool to:

- List all available audio devices (`-a` flag)
- Get the current active device (`-c` flag)
- Switch between devices (`-s` flag)
- Filter by device type: `output` or `input` (`-t` flag)

Devices are displayed with visual indicators to quickly identify the currently active device.

## License

MIT License - see [LICENSE](LICENSE) file for details.
