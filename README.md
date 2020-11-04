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
Before installing Lightning please check that your OS counts with the following **dependencies**:

* **docker-ce** (Docker Community Edition)
A complete guide for installing Docker can be found in the official documentation of the project: https://docs.docker.com/

On the left panel: **Get Docker** -> **Docker CE** -> **Linux** -> Select your distro and follow the instructions.

* **utilities**: brctl (command line tool for ethernet bridges manipulation), xmllint (XML parser), evince (PDF viewer), git
```bash
# apt-get install bridge-utils libxml2-utils evince git mate-terminal
```
* **other utilities** that may probably be already installed in your OS:
```
# apt-get install sudo bash x11-utils libc-bin coreutils iproute2 iptables mawk sed python3 python3-pip
```
* **Python dependencies** for the scenario verbaliser:
``` bash
# python3 -m pip install --update pip
# python3 -m pip install lxml
```

## Install the program
* **Get the last version of the original project**
```bash
$ git clone https://github.com/ptoribi/lightning.git
```
* **or this fork for the scenario verbaliser, which is not yet integrated in the original SW**
```bash
$ git clone https://github.com/paaguti/lightning.git
```

* **Change default locations** (Optional)
In order to set the location where the application folder and the symlink to the main program will be installed, you can change inside the **lightning/install** file the variables **LIGHTNING_INSTALLATION_DIRECTORY** and **SYMLINK_INSTALLATION_DIRECTORY**.

Please ensure before installing that those paths are included in your system's PATH variable. If you have no special needs the default values just work well.

* **Install Lightning**
```bash
$ sudo lightning/install
```

## After the installation:
The user "root" should not execute Lightning directly, only regular users should. Regular users must execute Lightning with root privileges, this can be done by using **one** of these four different ways:

* **Adding the current user to the sudo group (warning!, that user will be allowed to execute all the programs in the system as root):**
```bash
$ sudo usermod -a -G sudo $(whoami)
```
* **Allowing that specific user to execute Lightning:**
```bash
$ sudo bash -c "echo 'USER_NAME ALL=(ALL) NOPASSWD: $(dirname $(readlink -f $(which lightning)))"/lightning"' >> /etc/sudoers"
```
* **Creating a new group and allowing all its members to execute Lightning, then adding the specific user to that group:**
```bash
$ sudo groupadd GROUP_NAME
$ sudo bash -c "echo '%GROUP_NAME ALL=NOPASSWD: $(dirname $(readlink -f $(which lightning)))"/lightning"' >> /etc/sudoers"
$ sudo usermod -a -G GROUP_NAME USER_NAME
```
* **Allowing all the users in the system to execute Lightning:**
```bash
$ sudo bash -c "echo 'ALL ALL=(ALL) NOPASSWD: $(dirname $(readlink -f $(which lightning)))"/lightning"' >> /etc/sudoers"
```

## Uninstall the program
```bash
$ sudo $(dirname $(readlink -f $(which lightning)))/uninstall
```

## How to use the program
The XML files describing the scenarios must be stored in the folder "scenarios" inside
the lightning installation folder, some default examples are provided. You can access it by executing:
```bash
$ cd $(dirname $(readlink -f $(which lightning)))/scenarios
```
For executing lightning, just type as a regular user in a shell:
```bash
$ lightning
```
For starting a network scenario:
```bash
$ lightning start SCENARIO_NAME
```
For stopping the last executed network scenario:
```bash
$ lightning stop
```
## Author
**Pablo Toribio** (under supervision of Dr. C.J. Bernardos Cano)

# EXTRAS

In specific cases, the terminals to access the lightning devices need to be launched from outside the VM.

You can set the `REMOTE` variable in `/usr/local/lightning/variables.conf` to control this behaviour.

Add (or set if present)
```bash
REMOTE=1
```
to `variables.conf`. When executing `lightning start <scenario>`,
the Docker commands to access the different devices will be printed out
to the console and to the file `$HOME/commands`.
You can then feed this into a script to launch local terminals to SSH
into the VM and execute the Docker scripts.
Additionally, the file `$HOME/description.txt` will be created with
a textual description of the scenario (in Spanish currently).

If you call lightning with
```bash
lightning -R 1 start <scenario>
```
you start and set `REMOTE=1` in `variables.conf` for future executions until you update lightning again.

To start and set `REMOTE=0` for this and subsequent executions,
```bash
lightning -R 0 start <scenario>
```
