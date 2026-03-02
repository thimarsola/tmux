#!/usr/bin/env bash

# Detect macOS appearance mode (Dark or Light)
# Returns the appropriate theme file path

THEME_DIR="$HOME/.config/tmux/themes"

# Check if running on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Get the system appearance mode
    appearance=$(defaults read -g AppleInterfaceStyle 2>/dev/null)

    if [[ "$appearance" == "Dark" ]]; then
        echo "$THEME_DIR/pinguim.conf"
    else
        echo "$THEME_DIR/solarized-light.conf"
    fi
else
    # Default to dark theme on non-macOS systems
    echo "$THEME_DIR/pinguim.conf"
fi
