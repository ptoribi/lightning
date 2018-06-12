# :zap: lightning :zap:
The simple and lightweight network simulator based on Docker containers

![Preview](https://raw.githubusercontent.com/ptoribi/lightning/master/screenshots/screenshot1.png) 

![Preview](https://raw.githubusercontent.com/ptoribi/lightning/master/screenshots/screenshot2.png)

## About lightning
Lightning is a simple and lightweight network simulator based on Docker containers.
Network scenarios are described in XML files that the program parses and interprets
for launching the networks and containers desired. Direct execution of the lightning functions is also
allowed.
Two Docker images are set by default, called "host" and "router":
*  **host** is a Debian based image with some programming and network management utilities inside
*  **router** is a Debian based OS with the Quagga routing suite installed

## Compatibility
Debian 9 x86_64 (compatibility with more OS will be checked in the nearly future)

## Before the installation
Before installing Lightning please check that your OS counts with the following dependencies:

* **docker-ce** (Docker Community Edition)
A complete guide for installing Docker can be found in the official documentation of the project: https://docs.docker.com/

On the left panel: **Get Docker** -> **Docker CE** -> **Linux** -> Select your distro and follow the instructions.

* **brctl** (command line tool for ethernet bridges manipulation)
```
$ sudo apt-get install bridge-utils
```
* **xmllint** (XML parser)
```
$ sudo apt-get install libxml2-utils
```
* **evince** (a regular PDF viewer)
```
$ sudo apt-get install evince
```
* **git** (optional, only if you want to use the git command for downloading Lightning)

Official documentation: https://git-scm.com/download/linux
```
$ sudo apt-get install git
```
* **other utilities** that may probably be already installed in your OS:
```
# apt-get install sudo bash x11-utils libc-bin coreutils iproute2 iptables mawk sed
```

## Install the program
* **Get the last version of the project**
```
$ git clone https://github.com/ptoribi/lightning.git
```
* **Change default locations** (Optional)

In order to set the location where the application folder and the symlink to the main program will be installed, you can change inside the **lightning/install** file the variables **LIGHTNING_INSTALLATION_DIRECTORY** and **SYMLINK_INSTALLATION_DIRECTORY**.

Please ensure before installing that those paths are included in your system's PATH variable. If you have no special needs the default values just work well.

* **Install Lightning**
```
$ sudo lightning/install
```

## After the installation:
The user "root" should not execute Lightning directly, only regular users should. Regular users must execute Lightning with root privileges, this can be done by using **one** of these four different ways:

* **Adding the specific user to the sudo group (warning!, that user will be allowed to execute all the programs in the system as root):**
```
$ sudo usermod -a -G sudo USER_NAME
```
* **Allowing that specific user to execute Lightning:**
```
$ sudo bash -c "echo 'USER_NAME ALL=(ALL) NOPASSWD: $(dirname $(readlink -f $(which lightning)))/lightning' >> /etc/sudoers"
```
* **Creating a new group and allowing all its members to execute Lightning, then adding the specific user to that group:**
```
$ sudo groupadd GROUP_NAME
$ sudo bash -c "echo '%GROUP_NAME ALL=NOPASSWD: $(dirname $(readlink -f $(which lightning)))/lightning' >> /etc/sudoers"
$ sudo usermod -a -G GROUP_NAME USER_NAME
```
* **Allowing all the users in the system to execute Lightning:**
```
$ sudo bash -c "echo 'ALL ALL=(ALL) NOPASSWD: $(dirname $(readlink -f $(which lightning)))/lightning' >> /etc/sudoers"
```

## Uninstall the program
```
$ sudo $(dirname $(readlink -f $(which lightning)))/uninstall
```

## How to use the program
The XML files describing the scenarios must be stored in the folder "scenarios" inside
the lightning installation folder, some default examples are provided. You can access it by executing:
```
$ cd $(dirname $(readlink -f $(which lightning)))/scenarios
```
For executing lightning, just type as a regular user in a shell:
```
$ lightning
```
For starting a network scenario:
```
$ lightning start SCENARIO_NAME
```
For stopping the last executed network scenario:
```
$ lightning stop
```
## Author       
**Pablo Toribio** (under supervision of Dr. C.J. Bernardos Cano)
