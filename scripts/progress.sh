#!/bin/bash

# Check if ImageMagick is installed
if ! command -v magick &> /dev/null; then
    echo "ImageMagick 'magick' is not installed. Install it first!"
    exit 1
fi

# Output directory
output_dir="../images"
mkdir -p "$output_dir"

# Path to the custom font
font_path="./RobotoCondensed-Regular.ttf"

# Check if the font exists
if [[ ! -f "$font_path" ]]; then
    echo "Font 'RobotoCondensed-Regular.ttf' not found in the current directory!"
    exit 1
fi

# Generate progress bar images
for i in $(seq 0 99); do
    percentage=$((i+1)) # Calculate percentage (1%, 2%, ..., 100%)

    # Apply new percentage logic
    if [[ $percentage -le 50 ]]; then
        magick -size 300x50 xc:none \
            -gravity center -font "$font_path" -pointsize 24 -fill red -annotate +0+0 "Loading..." \
            "$output_dir/progress-$(printf "%02d" $i).png"
    else
        percentage=$(( (percentage - 50) * 2 )) # For percentages > 50, scale to 0-100

        width=$((10 + 280 * percentage / 100)) # Adjust the width based on the new percentage
    
        # Create the progress bar image
        magick -size 300x50 xc:none \
            -fill white -stroke none -draw "roundrectangle 10,20,$width,30,5,5" \
            -gravity center -font "$font_path" -pointsize 24 -fill red -annotate +0+0 "${percentage}%" \
            "$output_dir/progress-$(printf "%02d" $i).png"
    
        echo "Generated: progress-$(printf "%02d" $i).png (${percentage}%)"
    fi
done

echo "All progress bars have been created in the directory '$output_dir'."

