#!/bin/bash
# This script will revert the installation of Jenkins on Ubuntu 20.04

# Colors for text formatting
RED='\033[0;31m'  # Red colored text
NC='\033[0m'      # Normal text
YELLOW='\033[33m'  # Yellow Color
GREEN='\033[32m'   # Green Color

display_error() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

# Stop Jenkins service
echo -e "${YELLOW}...Stopping Jenkins service...${NC}"
sudo systemctl stop jenkins || display_error "Failed to stop Jenkins service."

# Remove Jenkins packages
echo -e "${YELLOW}...Removing Jenkins packages...${NC}"
sudo apt-get remove --purge jenkins -y || display_error "Failed to remove Jenkins packages."

# Remove Jenkins home directory
echo -e "${YELLOW}...Removing Jenkins home directory...${NC}"
sudo rm -rf /var/lib/jenkins || display_error "Failed to remove Jenkins home directory."

# Remove Jenkins configuration files
echo -e "${YELLOW}...Removing Jenkins configuration files...${NC}"
sudo rm -rf /etc/default/jenkins || display_error "Failed to remove Jenkins configuration files."

# Remove Jenkins plugins directory
echo -e "${YELLOW}...Removing Jenkins plugins directory...${NC}"
sudo rm -rf /var/lib/jenkins/plugins || display_error "Failed to remove Jenkins plugins directory."

# Remove Jenkins log files
echo -e "${YELLOW}...Removing Jenkins log files...${NC}"
sudo rm -rf /var/log/jenkins || display_error "Failed to remove Jenkins log files."

# Clean APT cache
echo -e "${YELLOW}...Cleaning APT cache...${NC}"
sudo apt-get clean || display_error "Failed to clean APT cache."

# Remove OpenJDK 11
echo -e "${YELLOW}...Removing OpenJDK 11...${NC}"
sudo apt-get remove --purge openjdk-11-jdk -y || display_error "Failed to remove OpenJDK 11."

# Verify removal
echo -e "${YELLOW}...Verifying removal...${NC}"
if [ -d "/var/lib/jenkins" ] || [ -f "/etc/default/jenkins" ]; then
    display_error "Verification failed. Jenkins-related files still exist."
else
    echo -e "${GREEN}Reversion completed successfully.${NC}"
fi
