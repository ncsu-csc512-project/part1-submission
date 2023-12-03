#!/usr/bin/env bash

# Function to display help
show_help() {
    echo "Usage: $0 [version]"
    echo "Install LLVM on Ubuntu."
    echo "  -h, --help    Show this help message"
    echo "  version       Specify the LLVM version to install (default: 17)"
}

# Check for help option
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# Default LLVM version
LLVM_VERSION=${1:-17}

# Download the installation script
echo "Downloading LLVM installation script..."
wget -q https://apt.llvm.org/llvm.sh

# Make the script executable
chmod u+x llvm.sh

# Execute the script with the specified LLVM version
echo "Installing LLVM version $LLVM_VERSION..."
sudo ./llvm.sh $LLVM_VERSION

# Cleaning up
rm llvm.sh

echo "LLVM version $LLVM_VERSION installed successfully."
