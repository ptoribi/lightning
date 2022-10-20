# Installing `lightning` on Apple silicon

*CAVEAT EMPTOR* This is just one possible path to installation, there may be other.

## Prerequisites

You will need the UTM hypervisor. Go to [the UTM homepage][https://mac.getutm.app/] and select the download mode that fits your needs. Install UTM on your computer.

Additionally you will need a Ubuntu 22.04 LTS image for ARM you can download from [https://ubuntu.com/download/server/arm]

## Launching UTM and creating a Ubuntu VM.

Select creating a virtual machine that uses virtualisation and then the Linux target.
  - Give the VM a minimum of 4 GBytes of RAM and 40 GBytes for the hard disk
  - Attach the .iso image you downloaded to a virtual CDROM device
  - Boot the machine and follow the installation instructions
  - *Don't install any additional packages*
  - Once the installation process is finished
    1. shutdown the VM with the `sudo shutdown` command in the default user
    2. eject the CDROM image from UTM

A good reference is provided in the [UTM VM gallery][https://mac.getutm.app/gallery/ubuntu-20-04]

## Installing the prerequisites for lightning

1. Refresh the package list with

   ```sudo apt update```
   
2. Add your user to the sudoers in order to avoid sudo asking for the password when invoked
   
   ```echo "$whoami: (ALL=ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$(whoami)```
   
3. Upgrade the packages
   
   ```sudo apt upgrade -y```
   
4. Install the XFCE desktop and additional tools
   
   ```sudo apt install -y ubuntu-xfce-desktop git nano```
   
5. Reboot the VM to get the desktop running

6. Launch a terminal and proceed to install `lightning` as described in the `README.md` file.
