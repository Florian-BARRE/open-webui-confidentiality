# Step 1: Use an official Node.js image
FROM node:20.18.1-bullseye-slim AS base

# Install system dependencies (curl, git, etc.)
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN curl -sSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -b -p /opt/conda \
    && rm /tmp/miniconda.sh

# Set the PATH so that conda is available globally
ENV PATH="/opt/conda/bin:${PATH}"

# Initialize conda for bash
RUN /opt/conda/bin/conda init bash

# Set the default shell to bash
SHELL ["/bin/bash", "--login", "-c"]

# Set the working directory
WORKDIR /app

# Expose necessary ports
EXPOSE 5173 8080

# Copy the start.sh script and give it execution permissions
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Set the command to run the start.sh script
CMD ["/app/start.sh"]

# Use a volume for the source code
VOLUME ["/app"]
