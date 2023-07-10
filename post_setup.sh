#!/bin/bash
# Script to execute after the complete installation
# Possible use: clean up temporary files
if [ $EUID -ne 0 ]; then
    echo "You must run this as root, try with sudo."
    exit 1
fi

echo 'Post setup script started.'
