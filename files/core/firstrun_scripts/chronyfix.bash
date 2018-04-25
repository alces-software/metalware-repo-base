systemctl stop chronyd
ntpdate <%= config.ntp.server %>
systemctl start chronyd
hwclock --systohc
