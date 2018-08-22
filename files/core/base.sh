#!/bin/bash
#(c)2017 Alces Software Ltd. HPC Consulting Build Suite
#Job ID: <%= domain.config.jobid %>
#Cluster: <%= domain.config.cluster %>

# Name Resolution
<% unless node.name == 'local' -%>
curl "<%= domain.hosts_url %>" > /etc/hosts
<% else -%>
echo "<%= config.networks.pri.ip %> <%= config.networks.pri.hostname %>" >> /etc/hosts
<% end -%>

# General packages
yum -y install git vim emacs xauth xhost xdpyinfo xterm xclock tigervnc-server ntpdate wget vconfig bridge-utils patch tcl-devel gettext net-tools bind-utils ipmitool
yum -y update --exclude=centos-release*
sed '/^exclude=/{h;s/=/=centos-release\* /};${x;/^$/{s//exclude=centos-release\*/;H};x}' /etc/yum.conf -i

# SSH
mkdir -m 0700 /root/.ssh
install_file authorized_keys /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
echo "StrictHostKeyChecking no" >> /root/.ssh/config

run_script chrony
run_script syslog
run_script postfix

