#!/bin/bash -eu

if [ $INSTALL_VSCODE_IDE = "true" ]
then

apt-get update
apt-get upgrade -y

python3 -m pip install autopep8
python3 -m pip install pylint

apt-get install -y curl

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
apt-get update
apt-get install -y code

sudo -u $DEV_USERNAME code --install-extension ms-vscode.cpptools
sudo -u $DEV_USERNAME code --install-extension ms-vscode.cmake-tools
sudo -u $DEV_USERNAME code --install-extension matepek.vscode-catch2-test-adapter
sudo -u $DEV_USERNAME code --install-extension ms-python.python
sudo -u $DEV_USERNAME code --install-extension himanoa.python-autopep8
sudo -u $DEV_USERNAME code --install-extension visualstudioexptteam.vscodeintellicode

fi
