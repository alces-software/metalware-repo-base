<% if (node.plugins.lustre.config.lustre_isserver rescue false) -%>
yum -y --enablerepo lustre-el7-server --enablerepo e2fsprogs-el7 update
yum -y --enablerepo lustre-el7-server --enablerepo e2fsprogs-el7 install lustre kmod-lustre-osd-ldiskfs

cat << EOF > /etc/modprobe.d/lustre.conf
options lnet networks=<%= node.plugins.lustre.config.lustre_networks %>
options ost oss_num_threads=96
options mdt mds_num_threads=96
EOF

<% elsif (node.plugins.lustre.config.lustre_isclient rescue false) -%>

yum -y --enablerepo lustre-el7-server install lustre-client

cat << EOF > /etc/modprobe.d/lustre.conf
options lnet networks=<%= node.plugins.lustre.config.lustre_networks %>
EOF

echo "<%= node.plugins.lustre.config.lustre_mountentry %>" >> /etc/fstab

<% end -%>
