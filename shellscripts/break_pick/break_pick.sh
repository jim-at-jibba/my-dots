#!/bin/bash

# Weighted Pomodoro Break Activity Picker
# This script randomly selects activities for pomodoro breaks based on assigned weights

# Default number of activities to select
num_selections=1

# Check if the config file exists
config_file="$HOME/.pomodoro_activities.toml"
if [ ! -f "$config_file" ]; then
    cat > "$config_file" << EOF
# Pomodoro Break Activities Configuration
# Format: activity_name = weight
# Higher weight = higher probability of being selected

[activities]
Mochi = 1
Kitchen = 0.7
Read = 0.5
Clean = 0.3
EOF
    echo "Created default config file at $config_file"
    echo "Edit this file to customize your break activities and their weights"
    echo
fi

function show_help {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo
    echo "Randomly selects weighted activities for pomodoro breaks"
    echo
    echo "Options:"
    echo "  -n, --number NUM       Number of activities to select (default: 1)"
    echo "  -f, --file FILEPATH    Use custom config file (default: $config_file)"
    echo "  -l, --list             List all available activities with their weights"
    echo "  -e, --edit             Open the config file in your default editor"
    echo "  -h, --help             Show this help message"
    echo
    echo "Config file format (TOML-like):"
    echo "  [activities]"
    echo "  ActivityName = Weight"
    echo "  (Higher weight = higher chance of being selected)"
    echo
    echo "Examples:"
    echo "  $(basename "$0")             # Select 1 random activity based on weights"
    echo "  $(basename "$0") -n 3        # Select 3 random activities"
    echo "  $(basename "$0") -f custom   # Use custom config file"
    echo "  $(basename "$0") -l          # List all activities and weights"
}

function edit_config {
    if [ -n "$EDITOR" ]; then
        $EDITOR "$config_file"
    elif [ -n "$VISUAL" ]; then
        $VISUAL "$config_file"
    elif command -v nano > /dev/null; then
        nano "$config_file"
    elif command -v vim > /dev/null; then
        vim "$config_file"
    else
        echo "No editor found. Please edit $config_file manually."
    fi
}

function list_activities {
    echo "Available activities with weights:"
    echo "--------------------------------"
    
    # Check if we've found the activities section
    in_activities_section=0
    
    # Parse the TOML-like file
    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
        
        # Check for activities section
        if [[ "$line" == "[activities]" ]]; then
            in_activities_section=1
            continue
        fi
        
        # If we're in the activities section and find another section, stop
        if [[ $in_activities_section -eq 1 && "$line" =~ ^\[.*\]$ ]]; then
            in_activities_section=0
            continue
        fi
        
        # Process activities
        if [[ $in_activities_section -eq 1 ]]; then
            # Extract activity and weight
            activity=$(echo "$line" | sed 's/=.*//' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
            weight=$(echo "$line" | sed 's/.*=//' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
            
            # Validate weight
            if [[ "$weight" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                echo "$activity = $weight"
            fi
        fi
    done < "$config_file" | sort -t= -k2 -rn
    
    echo
    
    # Calculate total weight
    total_weight=0
    in_activities_section=0
    
    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
        
        # Check for activities section
        if [[ "$line" == "[activities]" ]]; then
            in_activities_section=1
            continue
        fi
        
        # If we're in the activities section and find another section, stop
        if [[ $in_activities_section -eq 1 && "$line" =~ ^\[.*\]$ ]]; then
            in_activities_section=0
            continue
        fi
        
        # Process activities
        if [[ $in_activities_section -eq 1 ]]; then
            # Extract weight
            weight=$(echo "$line" | sed 's/.*=//' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
            
            # Validate weight and add to total
            if [[ "$weight" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                total_weight=$(echo "$total_weight + $weight" | bc)
            fi
        fi
    done < "$config_file"
    
    echo "Total weight: $total_weight"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--number)
            num_selections="$2"
            shift 2
            ;;
        -f|--file)
            config_file="$2"
            shift 2
            ;;
        -l|--list)
            list_activities
            exit 0
            ;;
        -e|--edit)
            edit_config
            exit 0
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Check if config file exists
if [ ! -f "$config_file" ]; then
    echo "Error: Config file not found: $config_file"
    exit 1
fi

# Validate number of selections
if ! [[ "$num_selections" =~ ^[0-9]+$ ]]; then
    echo "Error: Number of selections must be a positive integer"
    exit 1
fi

# Read activities and weights from config file
activities=()
weights=()

# Parse the TOML-like file
in_activities_section=0

while IFS= read -r line; do
    # Skip comments and empty lines
    [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
    
    # Check for activities section
    if [[ "$line" == "[activities]" ]]; then
        in_activities_section=1
        continue
    fi
    
    # If we're in the activities section and find another section, stop
    if [[ $in_activities_section -eq 1 && "$line" =~ ^\[.*\]$ ]]; then
        in_activities_section=0
        continue
    fi
    
    # Process activities
    if [[ $in_activities_section -eq 1 ]]; then
        # Extract activity and weight
        activity=$(echo "$line" | sed 's/=.*//' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
        weight=$(echo "$line" | sed 's/.*=//' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
        
        # Validate weight
        if ! [[ "$weight" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            echo "Warning: Invalid weight for \"$activity\", skipping"
            continue
        fi
        
        activities+=("$activity")
        weights+=("$weight")
    fi
done < "$config_file"

# Check if we have any valid activities
if [ ${#activities[@]} -eq 0 ]; then
    echo "Error: No valid activities found in config file"
    exit 1
fi

# Cap number of selections to available activities
if [ "$num_selections" -gt "${#activities[@]}" ]; then
    echo "Note: Requested $num_selections activities but only ${#activities[@]} are available"
    num_selections=${#activities[@]}
fi

# Calculate cumulative weights for weighted random selection
cumulative_weights=()
sum=0
for weight in "${weights[@]}"; do
    sum=$(echo "$sum + $weight" | bc)
    cumulative_weights+=("$sum")
done

# Function to select one weighted random activity
function select_weighted_activity {
    # Generate random number between 0 and the sum of weights
    random=$(echo "scale=6; $RANDOM/32767 * $sum" | bc)
    
    # Find the index where random falls in the cumulative weights
    for i in "${!cumulative_weights[@]}"; do
        if (( $(echo "$random < ${cumulative_weights[$i]}" | bc -l) )); then
            echo "${activities[$i]}"
            return
        fi
    done
    
    # Fallback to last activity (should rarely happen)
    echo "${activities[-1]}"
}

# Select the requested number of activities
echo "Selected break activities:"
echo "------------------------"

selected=()
for ((i=1; i<=num_selections; i++)); do
    # Try up to 5 times to get a unique activity
    for ((attempt=1; attempt<=5; attempt++)); do
        pick=$(select_weighted_activity)
        
        # Check if this activity was already selected
        already_selected=0
        for selected_activity in "${selected[@]}"; do
            if [[ "$selected_activity" == "$pick" ]]; then
                already_selected=1
                break
            fi
        done
        
        # If unique or we've tried 5 times, use this pick
        if [[ $already_selected -eq 0 || $attempt -eq 5 ]]; then
            break
        fi
    done
    
    # Add to selected list and output
    selected+=("$pick")
    echo "$i. $pick"
done

echo
echo "Happy pomodoro break! 🍅"