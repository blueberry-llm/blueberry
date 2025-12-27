FROM pytorch/pytorch:2.9.1-cuda13.0-cudnn9-devel

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV OMP_NUM_THREADS=1
ENV BLUEBERRY_BASE_DIR="/root/.cache/blueberry"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Create cache directory
RUN mkdir -p $BLUEBERRY_BASE_DIR

# Install uv (Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv to PATH
ENV PATH="/root/.cargo/bin:$PATH"

# Set working directory
WORKDIR /app

# Copy the entire blueberry project
COPY . .

# Make speedrun.sh executable
RUN chmod +x speedrun.sh

# Expose any necessary ports (for web UI)
EXPOSE 7860

# Default command to run speedrun.sh
CMD ["bash", "speedrun.sh"]