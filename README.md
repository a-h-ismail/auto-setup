# linux-setup

## Introduction

`linux-setup` is a set of scripts and a configuration file that helps you setup your Linux system. Requires coreutils, a package manager, `acl` tools and the `ping` command.

## Features

- Standalone (does not require client/server).
- Supports Debian/Ubuntu and Fedora systems.
- Install/Remove packages using `apt` or `dnf`.
- Install using Flatpak.
- Copy a directory contents or a file to the specified destination (can set ACLs according to `acls.txt`, generate using `getfacl`).
- Enable systemd units (system and per user).
- Can run scripts before the setup, after installing packages and after setup.

## Configuration

The configuration file is `linux-setup.conf`.

### Format

The file contains sections describing your system configuration. The format is:

```bash
[Section 1]
# This is a comment
<configuration>

[Section 2]
...
```

- Available sections: System, Add Packages, Remove Packages, Flatpak, Groups, Users, Files, System Units, User Units, Pre, Post Packages, Post, Self Delete
- Documentation of each section is in the sample configuration file.

### Execution Order

- Read configuration file.
- Pre setup script.
- Install packages using `apt` or `dnf`, then upgrade all packages.
- Remove packages.
- Install Flatpaks
- Execute post package install script.
- Add groups.
- Add users.
- Copy files and directories.
- Enable systemd user units (services, timers...).
- Enable systemd system units.
- Execute post setup script.
- Execute self delete script and remove installer directory if requested.

Note: A step is skipped if the relevant configuration section is empty, or if a specific commandline option is provided.

### Command Line Arguments

```
Usage: ./linux-setup.sh [OPTIONS]
    
    --no-package-install     Skip package installation and upgrade step
    --no-package-remove      Skip package removal
    --no-flatpak             Skip Flatpak installation
    --no-useradd             Skip user add/modify
    --no-groupadd            Skip group add/modify
    --no-user-units          Skip systemd user(s) units installation
    --no-system-units        Skip systemd system units installation
    --no-file-copy           Skip file and directory copy step
    --no-preinst             Skip preinstall script
    --no-postinst            Skip postinstall script
    --no-post-package        Skip post package install script

    Other options:

    --self-delete            Remove the setup directory after executing the self delete script
    --help                   Print this help prompt
```

## Installation

Clone the repository and mark the scripts as executable

```bash
git clone https://gitlab.com/a-h-ismail/linux-setup.git
cd linux-setup
chmod +x *.sh
```

After writing your configuration and extra scripts/files, run the setup script: `sudo ./linux-setup.sh`.

Since these scripts will be run with root privileges, you should store them safely to avoid malicious code execution as root.
