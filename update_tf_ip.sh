#!/bin/bash

# Get the public IP address
PUBLIC_IP=$(curl -s ifconfig.me)

# Define the path to your Terraform configuration file
TF_FILE="main.tf"

# Update the main.tf file with the new public IP address
sed -i.bak "s/<PUBLIC_IP_PLACEHOLDER>/$PUBLIC_IP/" "$TF_FILE"

# Print a confirmation message
echo "Updated $TF_FILE with public IP address: $PUBLIC_IP"
