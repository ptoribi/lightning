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
* **or this forkfor the scenario verbaliser, which is not yet integrated in the original SW**
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

# EXTRAS (paaguti)

## Remote execution of lightning

In specific cases, the terminals to access the lightning devices need to be launched from outside the VM.

In this case, when executing `lightning start <scenario>`, the Docker commands to access the different devices
will be printed out to the console and to the file `$HOME/commands`.
You can then feed this file into a script that launches local terminals in the host, which docker through SSH
into the VM and access the different containers.
Additionally, lightning will create the file `$HOME/description.txt` with a textual description of the scenario
(in Spanish currently).

Check the value for `REMOTE` in `variables.conf`. If set to `0`, it will work inside the VM, launching the terminals and presenting the scenario wallpaper. If set to `1` lightning will start inside the VM, but expect the terminals
to access the containers to be executed in the host.

You can change the value of the `REMOTE` variable by launching `lightning` with the `-R` flag:

``` bash
lightning -R <value for REMOTE> start <scenario>
```

The value should be `0` or `1`  and will be kept until the next `lightning update`.

The default value for `REMOTE` is `0`

## sysctl customisation

Customisation for the sysctl.conf files inside the containers is provided by `/usr/local/lightning/sysctl-router.conf` for *router* containers and `/usr/local/lightning/sysctl-host.conf` for *host* containers. These files provide a way to define the *default*  values of specific variables. Manipulation is still handled by `lightning`.
