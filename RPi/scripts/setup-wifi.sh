#!/bin/bash -eu

if [ ! -z "$WIFI_SSID" ]; then

    echo 'ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev' >> /boot/wpa_supplicant.conf 
    echo 'update_config=1' >> /boot/wpa_supplicant.conf
    echo 'country=US' >> /boot/wpa_supplicant.conf
    echo 'network={' >> /boot/wpa_supplicant.conf
    echo "    ssid=\"${WIFI_SSID}\"" >> /boot/wpa_supplicant.conf
    
    if [ ! -z "$WIFI_PASSWORD" ]; then
        echo "    psk=\"${WIFI_PASSWORD}\"" >> /boot/wpa_supplicant.conf
        echo '    key_mgmt=WPA-PSK' >> /boot/wpa_supplicant.conf
    else
        echo '    key_mgmt=NONE' >> /boot/wpa_supplicant.conf
    fi
    
    echo '}' >> /boot/wpa_supplicant.conf

fi
