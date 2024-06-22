#!/bin/bash

# Check if Rust is installed
if ! command -v rustc &> /dev/null
then
    echo "Rust is not installed. Installing Rust..."

    # Install Rust using rustup (recommended method)
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # Add Cargo's bin directory to the PATH environment variable
    source $HOME/.cargo/env

    echo "Rust has been successfully installed."
else
    echo "Rust is already installed. Skipping installation."
fi

# Display Rust version
echo "Rust version:"
rustc --version
cargo --version  # Optionally, display Cargo version too

# Install Caracal using Cargo
cargo install --git https://github.com/crytic/caracal --profile release --force

# Set up Python virtual environment and install Slither
python3 -m venv venv
source ./venv/bin/activate
pip install transformers[torch]
python3 -m pip install slither-analyzer

# Navigate to the project root directory (assuming the script is run from the project root)
cd "$(dirname "$0")"

# Check if Node.js is installed
if ! command -v node &> /dev/null
then
    echo "Node.js is not installed. Installing Node.js..."

    # Install Node.js (you can choose a different method if you prefer)
    curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
    sudo apt-get install -y nodejs

    echo "Node.js has been successfully installed."
else
    echo "Node.js is already installed. Skipping installation."
fi

# Check if bun is installed
if ! command -v bun &> /dev/null
then
    echo "bun is not installed. Installing bun..."

    # Install bun (ensure the script is correct for your system)
    curl -fsSL https://bun.sh/install | bash

    # Add bun to the PATH
    source $HOME/.bun/bin/bun

    echo "bun has been successfully installed."
else
    echo "bun is already installed. Skipping installation."
fi

# Clean up old node_modules and package-lock.json
rm -rf node_modules package-lock.json

# Install frontend dependencies using bun
bun install

# Run the frontend
bun run dev &

# Navigate to the server directory and run the backend
cd server

# Clean up old node_modules and package-lock.json in server directory
rm -rf node_modules package-lock.json

# Install backend dependencies using bun
bun install

node index.js

# Wait for both processes to complete (optional)
wait
