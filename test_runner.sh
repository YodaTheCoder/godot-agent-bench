#!/bin/bash

# Simple test runner for this project
echo "Running GUT tests..."

# Check if Godot is available
if command -v godot &> /dev/null; then
    echo "Godot found, running tests..."
    godot --headless --project . --path . --quit --script addons/gut/gut_cmdln.gd
else
    echo "Godot not found. Please install Godot and try again."
    exit 1
fi