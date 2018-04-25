firewall-cmd --add-port 514/udp --zone internal --permanent
firewall-cmd --add-port 514/tcp --zone internal --permanent
firewall-cmd --reload
