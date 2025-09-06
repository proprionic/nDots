#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to clone repository and move files
clone_repo() {
    echo "Cloning nDots repo..."
    if ! command_exists git; then
        echo "Error: git is not installed."
        exit 1
    fi

    if ! git clone https://github.com/proprionic/nDots.git; then
        echo "Error: Failed to clone repository."
        exit 1
    fi

    echo "Moving files to $HOME/.config..."
    if [ ! -d "$HOME/.config" ]; then
        echo "Creating $HOME/.config directory..."
        mkdir -p "$HOME/.config" || { echo "Error: Failed to create $HOME/.config"; exit 1; }
    fi

    cd nDots || { echo "Error: Failed to enter nDots directory"; exit 1; }
    # Move all files, including hidden ones, but avoid overwriting without backup
    for file in * .*; do
        if [ "$file" != "." ] && [ "$file" != ".." ]; then
            if [ -e "$HOME/.config/$file" ]; then
                echo "Warning: $HOME/.config/$file already exists, backing up..."
                mv "$HOME/.config/$file" "$HOME/.config/$file.bak" || { echo "Error: Backup failed"; exit 1; }
            fi
            mv "$file" "$HOME/.config/" || { echo "Error: Failed to move $file"; exit 1; }
        fi
    done
    cd .. && rm -rf nDots
    echo "Repository files moved successfully."
}

# Detect distribution
if [ -f /etc/os-release ]; then
    distro=$(grep -w ^ID /etc/os-release | cut -d= -f2 | tr -d '"')
else
    echo "Error: /etc/os-release not found. Cannot detect distribution."
    exit 1
fi

# Check if the distribution is Arch Linux
if [ "$distro" != "arch" ]; then
    echo "Error: This script is designed for Arch Linux only, detected: $distro"
    exit 1
fi

echo "Arch Linux detected."
if ! command_exists pacman; then
    echo "Error: pacman not found. Is this really Arch Linux?"
    exit 1
fi

echo "Updating system..."
if ! sudo pacman -Syu --noconfirm; then
    echo "Error: System update failed."
    exit 1
fi

echo "Installing packages..."
if ! sudo pacman -S --needed --noconfirm base-devel git hyprland neovim fish kitty waybar wofi; then
    echo "Error: Package installation failed."
    exit 1
fi

echo "Changing shell to fish..."
if command_exists fish; then
    if ! chsh -s /usr/bin/fish; then
        echo "Error: Failed to change shell to fish."
        exit 1
    fi
    echo "Shell changed to fish. Log out and back in to apply."
else
    echo "Error: fish is not installed."
    exit 1
fi

clone_repo
