#!/bin/bash

# Start the frontend server
echo "Starting the frontend server..."
npm run dev &

# Wait a few seconds to ensure the frontend server starts
sleep 5

# Initialize conda and activate the backend environment
echo "Initializing conda and activating the backend environment..."
conda init bash
source ~/.bashrc
conda activate open-webui

# Navigate to the backend directory and start the backend server
echo "Starting the backend server..."
cd backend
sh dev.sh
