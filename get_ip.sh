#!/bin/bash
# Fetch current public IP address
CURRENT_IP=$(curl -s ifconfig.me)
echo "{\"ip\": \"$CURRENT_IP\"}"

