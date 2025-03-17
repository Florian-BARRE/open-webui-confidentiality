#!/bin/bash

# Function to print section headers with separators
print_section_header() {
    local section_name="$1"
    local separator="========================================"
    echo -e "\n\e[1;34m$separator\e[0m"
    echo -e "\e[1;34m$section_name\e[0m"
    echo -e "\e[1;34m$separator\e[0m\n"
}

# Start the frontend server
print_section_header "Starting the frontend server..."
npm run dev &

# Wait a few seconds to ensure the frontend server starts
sleep 5

# Initialize conda and activate the backend environment
print_section_header "Initializing conda and activating the backend environment..."
source ~/.bashrc
conda init bash
conda activate open-webui

# Navigate to the backend directory and start the backend server
print_section_header "Starting the backend server..."
cd backend
sh dev.sh
