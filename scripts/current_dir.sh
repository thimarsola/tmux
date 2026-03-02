#!/bin/bash

# icon_dir="  "
icon_dir="  "
icon_branch=" "
# icon_unpushed=" "
icon_dots="󰇘"
icon_tilda="󰜥"
icon_unpushed="↑"
icon_behind="↓"
icon_both="⇅"
icon_dirty="󰦒"

# Get current directory from tmux pane
dir_name=$(tmux display-message -p -F "#{pane_current_path}")
full_dir=$dir_name

# extract the last directory names if they exists with home prefix
if [[ "$dir_name" == "$HOME"* ]]; then
    dir_name="~${dir_name#$HOME}"
fi

dir_name=$(echo "$dir_name" | awk -F'/' '{print $NF}')

# # count how many levels deep we are from home
# depth=$(echo "$full_dir" | awk -F'/' '{print NF-1}')
#
# if [ $depth -gt 1 ]; then
#     dir_name="$icon_tilda/$icon_dots/$dir_name"
# else
#     dir_name="$icon_tilda/$dir_name"
# fi
#

# Check if we're in a git repository and get branch name
output="$dir_name"

cd "$full_dir" 2>/dev/null

if git rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        # Check for unpushed commits
        ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
        behind=$(git log --oneline ..@{upstream} 2>/dev/null)

        # Check if there are pending changes
        if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
            # Has changes - use yellow color
            output="$output  #[fg=#9da9a0]$icon_branch$branch $icon_dirty "

        elif [[ -n "$ahead" ]] && [[ -n "$behind" ]]; then
            output="$output #[fg=#a7c080]$icon_both $branch"

        elif [ "$ahead" -gt 0 ]; then
            # Has unpushed commits - use upload icon
            output="$output #[fg=#a7c080]$icon_unpushed $branch"

        elif [[ -n "$behind" ]]; then
            # Has behind commits - use download icon
            output="$output #[fg=#9da9a0]$icon_behind $branch"

        else
            # No changes - use default color
            output="$output  $icon_branch$branch"
        fi
    fi
fi

echo -n " $output"
