#!/bin/bash
# Kill any existing Python HTTP servers on port 8080
pkill -f "python3 -m http.server 8080"

# Clear and rebuild dist folder
rm -rf dist
mkdir -p dist
find . -type f \( -name "*.html" -o -name "*.css" -o -name "*.js" -o -name "*.png" -o -name "*.jpg" -o -name "*.svg" -o -name "*.ico" \) | cpio -pdm dist

# Start server in the background
cd dist
nohup python3 -m http.server 8080 &>/dev/null &

# Open in Chrome (Android)
termux-open-url http://127.0.0.1:8080
