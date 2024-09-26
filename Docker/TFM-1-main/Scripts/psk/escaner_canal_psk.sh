#!/bin/bash

rm -rf Docker/TFM-1-main/Scripts/psk/wifi
mkdir Docker/TFM-1-main/Scripts/psk/wifi

sudo airodump-ng wlan1mon -w Docker/TFM-1-main/Scripts/psk/wifi/captura -c 6