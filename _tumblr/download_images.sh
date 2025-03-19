#!/bin/bash

set -e

# Store the current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"  # Change to the script's directory

# Base directory for cached images (relative to project root)
BASE_DIR="../img/tumblr"
mkdir -p "$BASE_DIR"

# Parse the JSON file
echo "Processing posts to download images..."
POSTS=$(cat all_posts.json | jq '.posts')
POST_COUNT=$(echo $POSTS | jq 'length')

echo "Found $POST_COUNT posts to process"

# Process each post and download its image
for i in $(seq 0 $(($POST_COUNT - 1))); do
    POST=$(echo $POSTS | jq ".[$i]")
    POST_ID=$(echo $POST | jq -r '.id')
    
    # Use the highest resolution image available (usually 1280px)
    IMAGE_URL=$(echo $POST | jq -r '.["photo-url-1280"] // .["photo-url-500"]')
    POST_DATE=$(echo $POST | jq -r '.["date-gmt"]')
    
    # Extract year and month from date
    # Format example: "2025-03-16 23:02:56 GMT"
    YEAR=$(echo $POST_DATE | cut -d'-' -f1)
    MONTH=$(echo $POST_DATE | cut -d'-' -f2)
    
    # Create year/month directory structure
    TARGET_DIR="$BASE_DIR/$YEAR/$MONTH"
    mkdir -p "$TARGET_DIR"
    
    # Extract file extension from URL
    EXTENSION="${IMAGE_URL##*.}"
    
    # Create filename for cached image
    CACHED_FILENAME="tumblr_${POST_ID}.${EXTENSION}"
    CACHED_PATH="$TARGET_DIR/${CACHED_FILENAME}"
    RELATIVE_PATH="/img/tumblr/$YEAR/$MONTH/${CACHED_FILENAME}"
    
    echo "Downloading image for post $POST_ID ($((i+1)) of $POST_COUNT)..."
    
    # Download the image if it doesn't exist
    if [ ! -f "$CACHED_PATH" ]; then
        curl -s "$IMAGE_URL" -o "$CACHED_PATH"
        echo "  Downloaded to $CACHED_PATH"
    else
        echo "  Image already exists at $CACHED_PATH"
    fi
    
    # Add the cached image path to the post data
    POSTS=$(echo $POSTS | jq --arg path "$RELATIVE_PATH" \
                          ".[$i] += {\"cached-image\": \$path}")
done

# Update the JSON file with the cached image paths
echo "{\"posts\": $POSTS}" > all_posts.json
echo "Updated all_posts.json with cached image paths"

# Return to the original directory
cd - > /dev/null

echo "Done downloading images!"
