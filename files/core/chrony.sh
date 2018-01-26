#!/bin/bash
#(c)2017 Alces Software Ltd. HPC Consulting Build Suite
#Job ID: <%= config.jobid %>
#Cluster: <%= config.cluster %>

yum -y install chrony
install_file chrony.conf /etc/chrony.conf
systemctl start chronyd
systemctl enable chronyd

# Firstrun script to correct time at system start
install_file chronyfix.bash /var/lib/firstrun/scripts/chronyfix.bash
