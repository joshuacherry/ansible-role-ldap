# ansible-role-ldap

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.org/joshuacherry/ansible-role-ldap.svg?branch=master)](https://travis-ci.org/joshuacherry/ansible-role-ldap)
![Ansible](https://img.shields.io/badge/ansible-2.5-blue.svg)
![Ansible](https://img.shields.io/badge/ansible-2.6-blue.svg)
![Ansible](https://img.shields.io/badge/ansible-2.7-blue.svg)

Configures LDAP authentication for a linux server using pam-ldapd and nscd.

## Requirements

- Ansible
  - Tested Versions:
    - 2.5
    - 2.6
    - 2.7

## Install

### Install from GitHub

`ansible-galaxy install git+https://github.com/joshuacherry/ansible-role-ldap.git`

## Features

- Authentication against Active Directory or LDAP

| Operating System   |
| :----------------- |
| Ubuntu 16.04       |
| Ubuntu 18.04       |
| Centos 7           |

## Versioning

For the versions available, see the [tags on this repository](https://github.com/joshuacherry/ansible-role-ldap/tags).

Additionaly you can see what change in each version in the [CHANGELOG.md](CHANGELOG.md) file.

## Role variables

Look to the [defaults](defaults/main.yml) properties file to see the possible configuration properties.

## Testing

This role includes a Vagrantfile used with a Docker-based test harness. Using Vagrant allows all contributors to test on the same platform and avoid false test failures due to untested or incompatible docker versions.

1. Install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).
1. Run `vagrant up` from the same directory as the Vagrantfile in this repository.
1. SSH into the VM with: `vagrant ssh`
1. Run tests with `molecule`.

### Testing with Docker and tox

Tox will test against the configured dependencies in [tox.ini](tox.ini). This allows you to test the role against multiple version of ansible, molecule, python, and more. Once the dependencies are set, tox will run the same molecule command to test code.

Due to how Virtualbox mounts shared folders, it is recommended to copy the role into a local directory within the virtual machine before running tox, otherwise the python environments will perform significantly slower. Run the below commands each time you make a change to the source code and need to test against all scenarios defined in [tox.ini](tox.ini)

```bash
rsync -ua /ansible-role-ldap/ ~/ansible-role-ldap/ --delete
cd ~/ansible-role-ldap
tox
```

### Testing with Docker and molecule

```bash
cd /ansible-role-ldap
molecule test
```

See `molecule` for more information including a full list of available commands.

### interactive debugging

You can use log into a docker image created by molecule for interactive testing with the below commands. As defined in [molecule.yml](molecule/default/molecule.yml), the default instance is set to `ubuntu1604`. If you wish to test other operating systems, you must define the environment variables `MOLECULE_DISTRO` and `MOLECULE_DOCKER_COMMAND`. A table of supported options are below.

```bash
cd /ansible-role-ldap
export MOLECULE_DISTRO=centos7
export MOLECULE_DOCKER_COMMAND=/usr/lib/systemd/systemd
molecule converge
docker exec -it instance /bin/bash
```

| OS            | MOLECULE_DISTRO | MOLECULE_DOCKER_COMMAND  |
| :------------ | :-------------: | :----------------------- |
| Ubuntu 16.04  | ubuntu1604      | /lib/systemd/systemd     |
| ubuntu 18.04  | ubuntu1804      | /lib/systemd/systemd     |
| Centos 7      | centos7         | /usr/lib/systemd/systemd |

## Example Playbook

```yml
---
- hosts: all
  tasks:
  - include_role:
      name: ldap
    vars:
      ldap_uri: ldap://domain.fqdn
      ldap_base: DC=domain,DC=fqdn
```