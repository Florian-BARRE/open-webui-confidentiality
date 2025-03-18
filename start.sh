#!/bin/bash

# Function to print section headers with separators
print_section_header() {
    local section_name="$1"
    local separator="========================================"
    echo -e "\n\e[1;34m$separator\e[0m"
    echo -e "\e[1;34m$section_name\e[0m"
    echo -e "\e[1;34m$separator\e[0m\n"
}

# Setup the frontend
print_section_header "Setting up the frontend..."

# Copy .env.example to .env
echo "Copying .env.example to .env..."
cp -RPp .env.example .env

# Install frontend dependencies
echo "Installing frontend dependencies..."
npm install --legacy-peer-deps

# Start the frontend server in the background and display output in real-time
print_section_header "Starting the frontend server..."
npm run dev | tee /dev/tty &

# Wait a few seconds to ensure the frontend server starts
sleep 5

# Initialize conda and activate the backend environment
print_section_header "Initializing conda and activating the backend environment..."
source /opt/conda/etc/profile.d/conda.sh

# Flag to track if the environment was created
env_created=false

# Check if the 'open-webui' conda environment already exists
if conda env list | grep -q "open-webui"; then
    echo "Conda environment 'open-webui' already exists. Activating it..."
else
    echo "Conda environment 'open-webui' not found. Creating it..."
    conda create --name open-webui python=3.11 -y
    env_created=true
fi

# Activate the conda environment
sh /opt/conda/etc/profile.d/conda.sh & conda init bash & conda activate open-webui

# Navigate to the backend directory
print_section_header "Setting up the backend..."
cd /app/backend

# Install backend dependencies only if the environment was just created
if [ "$env_created" = true ]; then
    echo "Installing backend dependencies..."
    pip install -r requirements.txt -U
else
    echo "Backend dependencies are assumed to be already installed."
fi

# Start the backend server
print_section_header "Starting the backend server..."
sh dev.sh


echo "Run !"
npm run dev