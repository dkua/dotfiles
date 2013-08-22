# This script downloads and names the boxes for my various Vagrant environments

# Download the Ubuntu 12.04 32-bit image
vagrant box add precise32-cloud http://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-vagrant-i386-disk1.box

# Download the Ubuntu 12.04 64-bit image
vagrant box add precise64-cloud http://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-vagrant-amd64-disk1.box

# Download the Ubuntu 13.04 64-bit image
vagrant box add raring64-cloud http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg-vagrant-amd64-disk1.box
