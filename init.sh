#!/bin/bash

# init.sh - Environment setup script for blueberry Docker container
# This script sets up the environment, installs all requirements,
# and then launches the speedrun.sh script

set -e  # Exit on any error

echo "🫐 Setting up Blueberry environment..."

# Set environment variables
export OMP_NUM_THREADS=1
export BLUEBERRY_BASE_DIR="$HOME/.cache/blueberry"
mkdir -p $BLUEBERRY_BASE_DIR

# Update package lists and install system dependencies
echo "📦 Installing system dependencies..."
apt-get update
apt-get install -y \
    curl \
    build-essential \
    pkg-config \
    python3-dev \
    git \
    screen

# Check if uv is installed, install if not
echo "🔧 Installing uv Python package manager..."
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Create and activate virtual environment
echo "🐍 Setting up Python virtual environment..."
[ -d ".venv" ] || uv venv
source .venv/bin/activate

# Install Python dependencies
echo "📚 Installing Python dependencies..."
uv sync --extra gpu

# Install Rust/Cargo for tokenizer
echo "🦀 Installing Rust/Cargo..."
if ! command -v cargo &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# Build the rustbpe tokenizer
echo "🔨 Building rustbpe tokenizer..."
uv run maturin develop --release --manifest-path blueberry/rustbpe/Cargo.toml

echo "✅ Environment setup complete!"
echo "🚀 Launching speedrun.sh..."

# Launch the speedrun script
exec bash speedrun.sh "$@"