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

- Be aware that sections are delimited by empty lines, so an empty line directly under the section will cause it to be skipped.
- Available sections: System, Add Packages, Remove Packages, Flatpak, Files, System Units, User Units, Pre, Post Packages, Post
- Documentation of each section is in the sample configuration file.

## Installation

Clone the repository and mark the scripts as executable

```bash
git clone https://gitlab.com/a-h-ismail/auto-setup.git
cd auto-setup
chmod +x *.sh
```

After writing your configuration and extra scripts/files, run the setup script: `sudo ./setup.sh`.

It expects root permissions so you should store it and associated scripts safely.
