# Defines our Vagrant environment
#
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
ROOT_FOLDER = File.basename(__dir__)


$setupScript = <<SCRIPT
echo -e "\n#########################################\n## Building Python 3.7 ##\n#########################################\n"
sudo apt-get update
sudo apt-get install -y build-essential
sudo apt-get install -y libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev 
wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
tar -xzvf Python-3.7.0.tgz
sudo Python-3.7.0/configure # --enable-optimizations
sudo make
sudo make install

echo -e "\n#########################################\n## Provisioning Docker ##\n#########################################\n"
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common bash-completion
sudo pip3 install --upgrade pip setuptools

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
# Show available version apt-cache madison docker-ce
sudo apt-get -o Dpkg::Options::="--force-confnew" install -y docker-ce

echo -e "\n#########################################\n## Install Packages with pip ##\n#########################################\n"
sudo pip install --upgrade \
  ansible=="2.7.*" \
  docker=="3.6.*"   \
  six=="1.11.*"              \
  molecule         \
  tox

sudo usermod -a -G docker vagrant

docker version

docker-compose version

molecule --version

ansible --version

pip -V
echo "###########################################"
echo "#                IP ADDRESS               #"
echo "#                                         #"
ip a | grep brd | egrep "[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\/[[:digit:]]{1,2}" | awk '{print "               ",$2}'
echo "###########################################"
SCRIPT

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "bento/ubuntu-16.04"
  config.vm.synced_folder ".", "/"+ROOT_FOLDER,
  owner: "vagrant", group: "vagrant",
  mount_options: ["dmode=777,fmode=777"]
  config.vm.define "server" do |host|
    host.vm.hostname = "server"
    config.vm.network "private_network", type: "dhcp"
    host.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    end
    host.vm.provision :shell, :inline => $setupScript
  end
end
