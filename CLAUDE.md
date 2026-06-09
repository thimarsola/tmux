# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal tmux configuration repository located at `~/.config/tmux/`. It provides a highly customized tmux setup with adaptive theming, session management, and various utility scripts.

## Key Architecture

### Configuration Loading Order

1. **Main config**: `tmux.conf` is the entry point (line 63: reload via `prefix + r`)
2. **Adaptive theming**: `themes/adaptive.conf` is sourced (line 113), which detects macOS appearance mode and loads either `pinguim.conf` (dark) or `solarized-light.conf` (light)
3. **Plugin initialization**: TPM (Tmux Plugin Manager) loads at the end (line 135)

### Theme System

The repository implements **adaptive theming** that responds to macOS system appearance:
- `themes/adaptive.conf`: Uses `if-shell` to check `AppleInterfaceStyle` and conditionally load themes
- `scripts/detect_theme.sh`: Alternative detection script that returns theme file paths
- Dark mode → `pinguim.conf` (custom dark theme with Nordic/Pinguim colors)
- Light mode → `solarized-light.conf` (currently configured) or `everforest-light.conf` (available alternative)
- All themes are self-contained `.conf` files with complete status bar, window, and pane styling

### Custom Scripts

Located in `scripts/`:
- **`current_dir.sh`**: Status bar component showing current directory name, git branch, and status icons (dirty, unpushed, behind). Used in status-right (pinguim.conf:36)
- **`memory_usage.sh`**: Cross-platform (macOS/Linux) memory usage display
- **`detect_theme.sh`**: Returns appropriate theme path based on system appearance
- **`cht.sh`**: Quick cheat sheet lookup via cht.sh/laravel

## Key Bindings & Configuration

### Custom Prefix
- Prefix changed from default `C-b` to **`C-s`** (tmux.conf:59)

### Window/Pane Management
- Vertical split: `prefix + =` (opens in current path)
- Horizontal split: `prefix + -` (opens in current path)
- Pane resizing: `prefix + Shift + H/J/K/L` (5 cell increments)
- Kill pane: `prefix + x` (no confirmation prompt)

### Session Management (with sesh + gum)
- `prefix + P`: Connect to existing session (filtered list)
- `prefix + O`: Create new session from zoxide list
- Popup terminal: `prefix + ,` (70% width/height, current path)

### Plugins in Use

Managed via TPM (`~/.config/tmux/plugins/tpm/`):
- `tmux-sensible`: Sensible defaults
- `tmux-autoreload`: Auto-reload config on changes
- `tmux-menus`: Enhanced menus
- `tmux-resurrect` + `tmux-continuum`: Session persistence (saves to `~/.config/tmux/sessions`)
- `tmux-prefix-highlight`: Visual prefix indicator
- `vim-tmux-navigator`: Seamless vim-tmux pane navigation
- `tmux-yank`: Clipboard integration
- `tmux-open`: URL/file opening

## Common Development Tasks

### Reload Configuration
```bash
# Inside tmux
prefix + r

# Or from shell
tmux source-file ~/.config/tmux/tmux.conf
```

### Install/Update Plugins
```bash
# Inside tmux
prefix + I  # Install new plugins
prefix + U  # Update plugins
prefix + alt + u  # Uninstall removed plugins
```

### Testing Scripts
```bash
# Test theme detection
bash ~/.config/tmux/scripts/detect_theme.sh

# Test current directory display
bash ~/.config/tmux/scripts/current_dir.sh

# Test memory usage
bash ~/.config/tmux/scripts/memory_usage.sh
```

### Switching Themes
To change themes, edit `themes/adaptive.conf` to source different theme files, or modify `tmux.conf:113` to directly source a specific theme.

## Important Notes

- **Session persistence**: `@resurrect-capture-pane-contents` is ON, `@continuum-restore` is ON (tmux.conf:131-132)
- **Vi mode**: Enabled for copy mode (tmux.conf:45)
- **Mouse support**: Enabled (tmux.conf:44)
- **Escape time**: Set to 0 for Vim performance (tmux.conf:29)
- **Base index**: Windows and panes start at 1, not 0 (tmux.conf:19-22)
- **Sessions persist**: `detach-on-destroy off` prevents session destruction when last window closes (tmux.conf:48)
