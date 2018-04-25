yum -y install dhcp

install_file dhcpd.conf /etc/dhcp/dhcpd.conf

touch /etc/dhcp/dhcpd.hosts

systemctl enable dhcpd
systemctl restart dhcpd
