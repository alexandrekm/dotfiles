#!/bin/bash

# Utility functions for cross-platform compatibility

set -e

# Detect the operating system
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Get the distribution name for Linux
get_linux_distro() {
    if command -v lsb_release &> /dev/null; then
        lsb_release -si | tr '[:upper:]' '[:lower:]'
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

# Check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Print colored output
print_status() {
    local color=$1
    local message=$2
    case $color in
        "green")  echo -e "\033[32m✅ $message\033[0m" ;;
        "yellow") echo -e "\033[33m⚠️  $message\033[0m" ;;
        "red")    echo -e "\033[31m❌ $message\033[0m" ;;
        "blue")   echo -e "\033[34m🔧 $message\033[0m" ;;
        *)        echo "📝 $message" ;;
    esac
}

# Create directory if it doesn't exist
ensure_dir() {
    local dir=$1
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        print_status "blue" "Created directory: $dir"
    fi
}

# Export functions for use in other scripts
export -f detect_os
export -f get_linux_distro
export -f command_exists
export -f print_status
export -f ensure_dir