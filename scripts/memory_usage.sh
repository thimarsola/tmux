#!/bin/bash

# Get current memory usage in MB
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    memory_used=$(vm_stat | awk '
        /Pages active/ { active = $3 }
        /Pages wired down/ { wired = $4 }
        /Pages occupied by compressor/ { compressed = $5 }
        END {
            gsub(/\.$/, "", active)
            gsub(/\.$/, "", wired) 
            gsub(/\.$/, "", compressed)
            used_pages = active + wired + compressed
            used_mb = (used_pages * 4096) / (1024 * 1024)
            printf "%.0f", used_mb
        }
    ')
    
    # Get total memory
    total_memory=$(sysctl -n hw.memsize)
    total_mb=$((total_memory / 1024 / 1024))
    
else
    # Linux
    memory_info=$(free -m | awk 'NR==2{printf "%d %d", $3, $2}')
    memory_used=$(echo $memory_info | cut -d' ' -f1)
    total_mb=$(echo $memory_info | cut -d' ' -f2)
fi

# Calculate percentage
if [ $total_mb -gt 0 ]; then
    percentage=$((memory_used * 100 / total_mb))
else
    percentage=0
fi

# Format output with appropriate units
if [ $memory_used -gt 1024 ]; then
    memory_gb=$(echo "scale=1; $memory_used / 1024" | bc)
    echo "${memory_gb}G (${percentage}%)"
else
    echo "${memory_used}M (${percentage}%)"
fi