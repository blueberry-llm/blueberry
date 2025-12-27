#!/bin/bash

# Build the Docker image
echo "Building Docker image..."
docker build -t blueberry:latest .

echo "Starting the speedrun in Docker container..."
docker-compose up --build