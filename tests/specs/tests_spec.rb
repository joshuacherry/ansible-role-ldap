# encoding: utf-8

control '01' do
  impact 1.0
  title 'Verify ldap'
  desc 'Ensures ldap package is installed'

  ldap_package = 'libpam-ldapd'
  ldap_package = 'nss-pam-ldapd' if os[:family] == 'redhat'
  describe package(ldap_package) do
    it { should be_installed }
  end
  describe package('nscd') do
    it { should be_installed }
  end

  if os[:family] == 'redhat'
    describe package('oddjob') do
      it { should be_installed }
    end
    describe package('oddjob-mkhomedir') do
      it { should be_installed }
    end
    describe package('authconfig') do
      it { should be_installed }
    end
  end

end

control '02' do
  impact 1.0
  title 'Verify services'
  desc 'Ensures services are up and running'

  describe service('nscd') do
    it { should be_enabled }
    it { should be_installed }
    it { should be_running }
  end
  describe service('nslcd') do
    it { should be_enabled }
    it { should be_installed }
    it { should be_running }
  end

  if os[:family] == 'redhat'
    describe service('oddjobd') do
      it { should be_enabled }
      it { should be_installed }
      it { should be_running }
    end
  end

end