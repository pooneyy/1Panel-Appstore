#!/bin/bash
# Script to replace anheyu/anheyu-backend with harbor.anheyu.com/anheyu/pro in docker-compose.yml
# Compatible with Ubuntu, CentOS, Debian and other Linux distributions
# Check if docker-compose.yml exists
if [ ! -f "./docker-compose.yml" ]; then
    echo "Error: ./docker-compose.yml file not found!"
    exit 1
fi
# Check if backup file already exists and remove it
if [ -f "./docker-compose.yml.back" ]; then
    echo "Existing backup file found, removing old backup..."
    rm ./docker-compose.yml.back
fi
# Create backup of original file
cp ./docker-compose.yml ./docker-compose.yml.back
echo "Backup created: ./docker-compose.yml.back"
# Replace anheyu/anheyu-backend with harbor.anheyu.com/anheyu/pro
sed -i 's|anheyu/anheyu-backend|harbor.anheyu.com/anheyu/pro|g' ./docker-compose.yml
# Check if replacement was successful
if grep -q "harbor.anheyu.com/anheyu/pro" ./docker-compose.yml; then
    echo "Successfully replaced anheyu/anheyu-backend with harbor.anheyu.com/anheyu/pro"
    echo "Changes applied to ./docker-compose.yml"
else
    echo "Warning: No replacements were made. Please check if 'anheyu/anheyu-backend' exists in the file."
fi
# Show the changes
echo ""
echo "Modified lines:"
grep "harbor.anheyu.com/anheyu/pro" ./docker-compose.yml || echo "No matching lines found"