#!/bin/bash -eu

apt-get install -y perl

cat << EOF > /opt/cleanupscript.sh
#!/bin/bash -eu
crontab -l | grep -v 'cleanupscript.sh' | crontab -
/usr/sbin/deluser --quiet --remove-home $SSH_USERNAME

if [ ! -z "$DEV_USERNAME" ]; then
    passwd --expire $DEV_USERNAME  
fi
EOF

chmod 777 /opt/cleanupscript.sh
chown root /opt/cleanupscript.sh
crontab -l | { cat; echo "@reboot /bin/bash /opt/cleanupscript.sh"; } | crontab -

usermod -s /sbin/nologin $SSH_USERNAME
