# Step 1: Use an official Node.js image with the recommended version
FROM node:20.18.1-bullseye-slim AS base

# Install dependencies including curl and git
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN curl -sSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm /tmp/miniconda.sh \
    && echo "export PATH=/opt/conda/bin:$PATH" >> ~/.bashrc

# Initialize Conda for bash
RUN /opt/conda/bin/conda init bash

# Set the default shell to bash
SHELL ["/bin/bash", "--login", "-c"]

# Step 2: Set the working directory
WORKDIR /app

# Clone the repository
RUN git clone https://github.com/Florian-BARRE/open-webui-confidentiality.git /app/

# Step 3: Configure the frontend
WORKDIR /app/

# Copy the .env.example file and rename it to .env
RUN cp -RPp .env.example .env

# Install frontend dependencies
RUN npm install

# Step 4: Configure the backend
WORKDIR /app/backend

# Create and activate the Conda environment for the backend
RUN /opt/conda/bin/conda create --name open-webui python=3.11 -y \
    && echo "conda activate open-webui" >> ~/.bashrc

# Install backend dependencies
RUN /opt/conda/envs/open-webui/bin/pip install -r requirements.txt -U

# Step 5: Expose necessary ports
EXPOSE 5173 8080

# Step 6: Copy the start.sh script and set executable permissions
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Step 7: Set the command to run the start.sh script
CMD ["/app/start.sh"]
