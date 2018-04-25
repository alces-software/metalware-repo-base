yum -y install tftp xinetd tftp-server syslinux syslinux-tftpboot php

mkdir -p <%= config.build.pxeboot_path %>
curl <%= if node.plugins.yumrepo.config.yumrepo_buildurl != nil then node.plugins.yumrepo.config.yumrepo_buildurl else 'http://mirror.ox.ac.uk/sites/mirror.centos.org/7/os/x86_64/' end %>/images/pxeboot/initrd.img > "<%= config.build.pxeboot_path %>/centos7-initrd.img"
curl <%= if node.plugins.yumrepo.config.yumrepo_buildurl != nil then node.plugins.yumrepo.config.yumrepo_buildurl else 'http:// mirror.ox.ac.uk/sites/mirror.centos.org/7/os/x86_64/' end %>/images/pxeboot/vmlinuz > "<%= config.build.pxeboot_path %>/centos7-kernel"
mkdir -p /var/lib/tftpboot/pxelinux.cfg/
install_file pxelinux_default /var/lib/tftpboot/pxelinux.cfg/default

sed -ie "s/^.*disable.*$/\    disable = no/g" /etc/xinetd.d/tftp

systemctl enable xinetd
systemctl restart xinetd
