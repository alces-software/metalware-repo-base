#!/bin/bash
<% if plugins.ipa.config.ipa_serverip != config.networks.pri.ip.to_s -%>

# Variables
REALM="<%= config.networks.pri.domain.upcase %>.<%= config.domain.upcase %>"

# Update resolv.conf
cat << EOF > /etc/resolv.conf
search <%= config.search_domains %>
nameserver <%= plugins.ipa.config.ipa_serverip %>
EOF

# Install packages
yum -y install ipa-client ipa-admintools

# Enroll host (using firstrun script)
cat << EOF > /var/lib/firstrun/scripts/ipaenroll.bash
ipa-client-install --no-ntp --mkhomedir --no-ssh --no-sshd --force-join --realm="$REALM" --server="<%= plugins.ipa.config.ipa_servername %>.<%= config.networks.pri.domain %>.<%= config.domain %>" -w "<%= plugins.ipa.config.insecurepassword %>" --domain="<%= config.networks.pri.domain %>.<%=config.domain %>" --unattended --hostname='<%= config.networks.pri.hostname %>'
EOF
<% end -%>