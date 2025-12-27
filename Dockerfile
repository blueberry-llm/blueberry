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
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install CUDA communication libraries
RUN apt-get update && apt-get install -y --allow-change-held-packages \
    libnccl2 \
    libnccl-dev \
    && rm -rf /var/lib/apt/lists/*

# Create cache directory
RUN mkdir -p $BLUEBERRY_BASE_DIR

# Install Rust and uv (Python package manager)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Add Rust and uv to PATH
ENV PATH="/root/.cargo/bin:$PATH"

# Create cache directory
RUN mkdir -p $BLUEBERRY_BASE_DIR

# Copy the entire blueberry project
COPY . .

# Make speedrun.sh executable
RUN chmod +x speedrun.sh

# Expose any necessary ports (for web UI)
EXPOSE 7860

# Default command to run speedrun.sh
CMD ["bash", "speedrun.sh"]