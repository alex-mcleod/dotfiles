#!/bin/bash

# Symlink .bash_profile and other profiles
echo "Making Terminal symlinks..."
cd ~; rm .bash_profile; ln -s ~/Dropbox/SoftwareDevelopment/system/.bash_profile .bash_profile

echo ""
echo "Finished!"
read -p "Press any key to exit."