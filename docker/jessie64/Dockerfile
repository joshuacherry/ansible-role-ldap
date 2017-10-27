# vim: set ft=dockerfile:

# Requires Ansible 1.8+ from jessie-backports.
FROM debian:jessie-backports

# Colour output.
ENV TERM=xterm

# Defaults to graphical.target.
RUN systemctl set-default multi-user.target

RUN apt-get update -y \
    && apt-get install -y apt-transport-https ca-certificates \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY chef.asc /tmp/chef.asc
COPY chef-stable.list /etc/apt/sources.list.d/chef-stable.list

RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 \
    && apt-key add /tmp/chef.asc \
    && apt-get update -y \
    && apt-get --no-install-recommends install -y \
      ansible=2.4.1.0-1* \
      git \
      sudo \
      inspec=1.43.5-1 \
      coreutils \
      net-tools \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*