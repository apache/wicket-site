#!/bin/bash

set -e

# Store the current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"  # Change to the script's directory

echo "Generating JSONP file from JSON data..."

# We'll work directly with the JSON data instead of the YAML
if [ ! -f "all_posts.json" ]; then
    echo "Error: all_posts.json not found. Please run fetch_posts.sh and download_images.sh first."
    exit 1
fi

# Use jq to extract and format the 20 most recent posts
jq '
  # Sort posts by date in descending order (most recent first)
  .posts |= sort_by(."date-gmt") | .posts |= reverse |
  # Take only the first 20 posts
  .posts |= .[0:20] |
  # Replace the original image URLs with cached versions
  .posts |= map(
    . + {
      "original-photo-url-500": .["photo-url-500"],
      "original-photo-url-1280": .["photo-url-1280"] 
    } | 
    if has("cached-image") then
      .["photo-url-500"] = .["cached-image"] | 
      .["photo-url-1280"] = .["cached-image"]
    else
      .
    end
  ) |
  # Add the tumblelog metadata
  . + {
    "tumblelog": {"title": "Built with Wicket"},
    "posts-total": (.posts | length),
    "posts-start": 0,
    "posts-type": "photo"
  }
' all_posts.json | jq -r tostring > "../tumblr.json"

echo "Created tumblr.json with the 20 most recent posts, using locally cached images"

# Return to the original directory
cd - > /dev/null

echo "Done!"
