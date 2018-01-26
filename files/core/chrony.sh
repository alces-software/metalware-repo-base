#!/bin/bash
#(c)2017 Alces Software Ltd. HPC Consulting Build Suite
#Job ID: <%= config.jobid %>
#Cluster: <%= config.cluster %>

yum -y install chrony
<% if config.ntp.is_server -%>
install_file chrony.conf.slave /etc/chrony.conf
<% else -%>
install_file chrony.conf.master /etc/chrony.conf
<% end -%>
systemctl start chronyd
systemctl enable chronyd

# Firstrun script to correct time at system start
install_file chronyfix.bash /var/lib/firstrun/scripts/chronyfix.bash
