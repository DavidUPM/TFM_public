#!/bin/bash

docker compose down

# Disable mac80211_hwsim
sudo modprobe mac80211_hwsim -r

sudo systemctl restart systemd-networkd

echo "INTERFACES BORRADAS"
