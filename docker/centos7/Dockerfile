FROM centos:7.2.1511

ENV TERM=xterm

RUN yum install -y --enablerepo=extras epel-release wget \ 
    && wget -O /tmp/ansible.rpm https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.4.0.0-1.el7.ans.noarch.rpm \
    && yum install -y /tmp/ansible.rpm \
    && rm /tmp/ansible.rpm \
    && yum clean all

    # Get version pip available versions
    # pip3 install ansible==randomwords

COPY chef.asc /tmp/chef.asc
COPY chef-stable.list /etc/yum.repos.d/chef-stable.repo

RUN rpm --import /tmp/chef.asc \
    && yum install -y inspec-1.25.0-1.el7
