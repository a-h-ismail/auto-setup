# auto-setup

## Introduction

Linux Auto Setup is a set of scripts and a configuration file that helps you setup your Linux system. It relies only on coreutils and other basic tools like `acl`.

## Features

- Standalone (does not require client/server).
- Supports Debian/Ubuntu and Fedora systems.
- Install/Remove packages using `apt` or `dnf`.
- Install using Flatpak.
- Copy a directory contents or a file to the specified destination (can set ACLs according to acls.txt, generate using `getfacl`).
- Enable systemd units (system and per user).
- Can run scripts before the setup, after installing packages and after setup.

## Configuration

The configuration file is `auto-setup.conf`.

### Format

The file contains sections describing your system configuration. The format is:

```bash
[Section 1]
# This is a comment
<configuration>

[Section 2]
...
```

- Available sections: System, Add Packages, Remove Packages, Flatpak, Groups, Users, Files, System Units, User Units, Pre, Post Packages, Post
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

Note: A step is skipped if the relevant configuration section is empty.

## Installation

Clone the repository and mark the scripts as executable

```bash
git clone https://gitlab.com/a-h-ismail/auto-setup.git
cd auto-setup
chmod +x *.sh
```

After writing your configuration and extra scripts/files, run the setup script: `sudo ./setup.sh`.

Since these scripts will be run with root privileges, you should store them safely to avoid malicious code execution as root.