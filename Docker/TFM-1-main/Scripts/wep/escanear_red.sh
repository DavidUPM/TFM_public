#!/bin/bash

rm -rf wep/wifi
mkdir wep/wifi

sudo airodump-ng wlan0mon -w wep/wifi/scan --wps --band abg