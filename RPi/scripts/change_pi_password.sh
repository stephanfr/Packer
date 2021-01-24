#!/bin/bash -eu

if [ ! -z "$NEW_PI_PASSWORD" ]; then

    echo "pi:${NEW_PI_PASSWORD}" | chpasswd
    
fi

