systemctl stop chronyd
<% if config.ntp.is_server -%>
ntpdate <%= (node.plugins.flightcenter.config.flightcenter_ntpserver rescue false) || '0.centos.pool.ntp.org' %>
<% else -%>
ntpdate <%= config.ntp.server %>
<% end -%>
systemctl start chronyd
hwclock --systohc
