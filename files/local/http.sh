yum -y install httpd

install_file deployment.conf /etc/httpd/conf.d/deployment.conf

install_file installer.conf /etc/httpd/conf.d/installer.conf

mkdir -p /opt/alces/installers

mkdir -p /var/lib/metalware/rendered/exec/
install_file kscomplete.php /var/lib/metalware/rendered/exec/kscomplete.php

systemctl enable httpd
systemctl restart httpd
