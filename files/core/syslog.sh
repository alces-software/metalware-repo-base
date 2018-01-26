#!/bin/bash
#(c)2017 Alces Software Ltd. HPC Consulting Build Suite
#Job ID: <%= config.jobid %>
#Cluster: <%= config.cluster %>

yum -y install rsyslog
<% if config.rsyslog.is_server -%>
install_file metalware.conf /etc/rsyslog.d/metalware.conf

sed -i -e "s/^#\$ModLoad imudp.*$/\$ModLoad imudp/g" /etc/rsyslog.conf
sed -i -e "s/^#\$UDPServerRun 514.*$/\$UDPServerRun 514/g" /etc/rsyslog.conf
sed -i -e "s/^#\$ModLoad imtcp.*$/\$ModLoad imtcp/g" /etc/rsyslog.conf
sed -i -e "s/^#\$InputTCPServerRun 514.*$/\$InputTCPServerRun 514/g" /etc/rsyslog.conf

install_file rsyslog-remote /etc/logrotate.d/rsyslog-remote

install_file firewall_rsyslog.bash /var/lib/firstrun/scripts/firewall_rsyslog.bash
<% else -%>
echo '*.* @<%= config.rsyslog.server %>:514' >> /etc/rsyslog.conf
<% end -%>

systemctl enable rsyslog
systemctl restart rsyslog
