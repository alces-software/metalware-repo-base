<% if config.dns_type.to_s == 'named' then %>
yum -y install bind bind-utils

install_file named.conf /etc/named.conf

touch /etc/named/metalware.conf

systemctl stop dnsmasq
systemctl disable dnsmasq

systemctl start named
systemctl enable named
<% else %>
systemctl stop named
systemctl disable named

yum install -y dnsmasq

systemctl start dnsmasq
systemctl enable dnsmasq
<% end %>
