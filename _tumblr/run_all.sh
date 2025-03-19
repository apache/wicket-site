#!/bin/bash

set -e

echo "Starting Tumblr data scraping process..."

# Store the current directory
ORIG_DIR="$(pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Make all scripts executable
chmod +x "$SCRIPT_DIR/fetch_posts.sh"
chmod +x "$SCRIPT_DIR/download_images.sh"
chmod +x "$SCRIPT_DIR/generate_jsonp.sh"

# Run the scripts in sequence
echo "Step 1: Fetching posts..."
"$SCRIPT_DIR/fetch_posts.sh"

echo "Step 2: Downloading images..."
"$SCRIPT_DIR/download_images.sh"

echo "Step 3: Generating JSONP file..."
"$SCRIPT_DIR/generate_jsonp.sh"

# Return to original directory
cd "$ORIG_DIR"

echo "Process complete!"
