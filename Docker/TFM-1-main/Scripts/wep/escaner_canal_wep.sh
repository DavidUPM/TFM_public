#!/bin/bash

rm -rf Docker/TFM-1-main/Scripts/wep/wifi
mkdir Docker/TFM-1-main/Scripts/wep/wifi

sudo airodump-ng -c 1 -w Docker/TFM-1-main/Scripts/wep/wifi/canal-1 --bssid F0:9F:C2:AA:19:29 wlan1mon