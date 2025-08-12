#!/bin/bash

# Install Terraform
echo "Installing Terraform..."
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs)"
sudo apt-get update && sudo apt-get install terraform

# Install PowerShell (if not already installed)
echo "Installing PowerShell..."
sudo apt-get update && sudo apt-get install -y wget apt-transport-https software-properties-common
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update && sudo apt-get install -y powershell

# Verify installations
echo "Verifying installations..."
terraform version
aws --version
pwsh --version

echo "Setup complete! Your CodeSpace is ready for PROG 8870 Final Project."
