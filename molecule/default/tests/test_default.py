"""
Runs Default tests
Available Modules: http://testinfra.readthedocs.io/en/latest/modules.html

"""
import os
import testinfra.utils.ansible_runner

TESTINFRA_HOSTS = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_ldap_is_installed(host):
    """
    Tests that ldap is installed
    """
    os_family = host.ansible("setup")["ansible_facts"]["ansible_os_family"]
    if os_family == "RedHat":
        ldapd_package = "nss-pam-ldapd"
    elif os_family == "Debian":
        ldapd_package = "libpam-ldapd"

    if os_family == "RedHat":
        oddjob = "oddjob"
        mkhomedir = "oddjob-mkhomedir"
        authconfig = "authconfig"
        assert host.package(oddjob).is_installed
        assert host.package(mkhomedir).is_installed
        assert host.package(authconfig).is_installed

    assert host.package(ldapd_package).is_installed
    assert host.package("nscd").is_installed


def test_ldap_running_and_enabled(host):
    """
    Tests that ldap is running and enabled
    """
    os_family = host.ansible("setup")["ansible_facts"]["ansible_os_family"]
    nscd = host.service("nscd")
    assert nscd.is_running
    assert nscd.is_enabled
    nslcd = host.service("nslcd")
    assert nslcd.is_running
    assert nslcd.is_enabled
    if os_family == "RedHat":
        oddjobd = host.service("oddjobd")
        assert oddjobd.is_running
        assert oddjobd.is_enabled
