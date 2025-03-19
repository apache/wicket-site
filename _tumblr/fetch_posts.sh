#!/bin/bash

set -e

# Store the current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"  # Change to the script's directory

# Create directory for _tumblr if it doesn't exist (not needed if already in _tumblr)
mkdir -p .

# First, get the total number of posts
echo "Fetching total post count..."
RESPONSE=$(curl -s "https://builtwithwicket.tumblr.com/api/read/json?callback=tumblr&sort=asc&num=0&start=0")
echo "$RESPONSE" > temp_response.json
TOTAL_POSTS=$(cat temp_response.json | jq -s -R '.[1+index("("): rindex(")")] | fromjson' | jq '.["posts-total"]')
echo "Total posts: $TOTAL_POSTS"

# Initialize an empty JSON array to hold all posts
echo '{"posts":[]}' > all_posts.json

# Fetch posts in batches of 50
START=0
BATCH_SIZE=50

while [ $START -lt $TOTAL_POSTS ]; do
    echo "Fetching posts $START to $((START + BATCH_SIZE - 1))..."
    RESPONSE=$(curl -s "https://builtwithwicket.tumblr.com/api/read/json?callback=tumblr&sort=asc&num=$BATCH_SIZE&start=$START")
    
    # Save the response to a temporary file
    echo "$RESPONSE" > temp_response.json
    
    # Extract the JSON from the JSONP response
    cat temp_response.json | jq -s -R '.[1+index("("): rindex(")")] | fromjson' > temp_json.json
    
    # Extract posts from this batch
    jq '.posts' temp_json.json > temp_batch_posts.json
    
    # Append these posts to our all_posts.json file
    # First, get the current posts
    jq '.posts' all_posts.json > temp_current_posts.json
    
    # Combine the current posts with the new ones
    jq -s '.[0] + .[1]' temp_current_posts.json temp_batch_posts.json > temp_combined_posts.json
    
    # Update the all_posts.json file
    jq '{posts: .}' temp_combined_posts.json > all_posts.json
    
    # Move to the next batch
    START=$((START + BATCH_SIZE))
done

echo "Saved all $TOTAL_POSTS posts to all_posts.json"

# Also save the complete tumblr JSON response using the last response
cat temp_json.json > tumblr.json

# Clean up temporary files
rm -f temp_*.json

# Return to the original directory
cd - > /dev/null

echo "Done!"
