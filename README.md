# ansible-role-ldap

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[![Build Status](https://travis-ci.org/joshuacherry/ansible-role-ldap.svg?branch=master)](https://travis-ci.org/joshuacherry/ansible-role-ldap)

Configures LDAP authentication for a linux server using pam-ldapd and nscd.

## Requirements

- none

## Install

### Install from GitHub

`ansible-galaxy install git+https://github.com/joshuacherry/ansible-role-ldap.git`

## Features

- Authentication against Active Directory or LDAP

| Operating System   | Tests Passed  |
| :----------------- | :-----------: |
| Debian >= 8.9      | ✓             |
| Ubuntu >= 16.04    | ✓             |
| Centos >= 7.2.1511 | ✓             |

## Versioning

[Semantic Versioning](http://semver.org/)

## Role variables

The following variable defaults are defined in `defaults/main.yml`.

`ldap_home_umask`\
(default: `0022`)\
The user file-creation mask is set to mask.

`ldap_uri`\
(default: `ldap://domain.fqdn`)\
Specifies the LDAP URI of the server to connect to. The URI scheme may be ldap, ldapi or ldaps, specifying LDAP over TCP, ICP or SSL respectively (if supported by the LDAP library).

`ldap_base`\
(default: `DC=domain,DC=fqdn`)\
Specifies the base distinguished name (DN) to use as search base. This option may be supplied multiple times and all specified bases will be searched.

`ldap_version`\
(default: `3`)\
Specifies the version of the LDAP protocol to use. The default is to use the maximum version supported by the LDAP library.

`ldap_scope`\
(default: `sub`)\
Specifies the search scope ([sub]tree, [one]level, base or children). The default scope is subtree; base scope is almost never useful for name service lookups; children scope is not supported on all servers.

`ldap_bind_timelimit`\
(default: `50`)\
Specifies the time limit (in seconds) to use when connecting to the directory server. This is distinct from the time limit specified in timelimit and affects the set-up of the connection only.

`ldap_search_timelimit`\
(default: `50`)\
Specifies the time limit (in seconds) to wait for a response from the LDAP server. A value of zero (0) is to wait indefinitely for searches to be completed.

`ldap_binddn`\
(default: `CN=service_account,OU=Users,DC=domain,DC=fqdn`)\
Specifies the distinguished name with which to bind to the directory server for lookups.

`ldap_bindpw`\
(default: `bindpassword-here`)\
Specifies the credentials with which to bind.

`ldap_tls_reqcert`\
(default: `never`)\
Specifies what checks to perform on a server-supplied certificate.

`ldap_pagesize`\
(default: `1000`)\
Set this to a number greater than 0 to request paged results from the LDAP server in accordance with RFC2696. The default (0) is to not request paged results. For OpenLDAP servers you may need to set sizelimit size.prtotal=unlimited for allowing more entries to be returned over multiple pages.

`ldap_referrals`\
(default: `yes`)\
Specifies whether automatic referral chasing should be enabled.

`ldap_idle_timelimit`\
(default: `800`)\
Specifies the period if inactivity (in seconds) after which the connection to the LDAP server will be closed.

`ldap_filters`\
The FILTER is an LDAP search filter to use for a specific map. The default is a multiline entry with basic filters on passwd, shadow, and group.

`ldap_nslcd_extra_params`\
This is a multiline variable for other miscellaneous configuration options in the nslcd.conf file. Common options to put in this variable would be additional filters and attribute maps.

## Testing

This role includes a Vagrantfile used with a Docker-based test harness that approximates the Travis CI setup for integration testing. Using Vagrant allows all contributors to test on the same platform and avoid false test failures due to untested or incompatible docker versions.

1. Install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).
1. Run `vagrant up` from the same directory as the Vagrantfile in this repository.
1. SSH into the VM with: `vagrant ssh`
1. Run tests with `make`.

### Testing with Docker and inspec

```bash
make -C /vagrant xenial64 test
```

See `make help` for more information including a full list of available targets.

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