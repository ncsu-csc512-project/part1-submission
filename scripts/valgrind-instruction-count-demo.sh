#!/usr/bin/env bash

# REPO_ROOT="$(git rev-parse --show-toplevel)"
SCRIPTS_DIR="$(dirname "$0")"
SCRIPTS_DIR="$(cd "$SCRIPTS_DIR" && pwd)"
# REPO_ROOT is the parent directory of the directory containing this script
REPO_ROOT="$(dirname "$SCRIPTS_DIR")"
VALGRIND_EXTRA_DIR="$REPO_ROOT/valgrind-extra"

# echo "$SCRIPTS_DIR"
# echo "$REPO_ROOT"
# exit 0

# Define the Valgrind directory
valgrind_dir=~/tmpdir/valgrind

# Create the directory if it doesn't exist
mkdir -p "$valgrind_dir"

# Clone the Valgrind repository if it doesn't exist
if [[ ! -d "$valgrind_dir/.git" ]]; then
    git clone https://sourceware.org/git/valgrind.git "$valgrind_dir"
fi
cd "$valgrind_dir" || exit

# Copy the ./branch directory to the Valgrind directory
# Note: Update this path if your ./branch directory is located elsewhere
# cp -r "$(dirname "$0")/branch" .
cp -vr "$REPO_ROOT/branch" .
cp -vf "$VALGRIND_EXTRA_DIR/configure.ac" .
cp -vf "$VALGRIND_EXTRA_DIR/Makefile.am" .

# Build Valgrind
./autogen.sh
./configure --prefix="$PWD/inst"
make install

# Indicate completion
echo "Valgrind has been successfully installed in $valgrind_dir"

inst/bin/valgrind --tool=branch date
