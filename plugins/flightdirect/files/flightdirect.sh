wget -O /tmp/flight-install <%= node.plugins.flightdirect.config.flightdirect_sourceurl %>

<% if node.plugins.flightdirect.config.flightdirect_isclient -%>
cat << EOF > /tmp/config.yml
roles:
- compute
facilities:
- software management
clustername: <%= config.cluster %>
masterip: ""
uuid: ""
token: ""
hostname: ""
hostprefix: ""
scheduler: ""
firewallrulepath: ""
nfspaths: []
nfscustompaths: ""
gridwarepath: /opt/gridware
sessiontypes: []
storagetypes: []
vpnport: ""
vpnnetwork: ""
vpnauth: ""
EOF
<% elsif node.plugins.flightdirect.config.flightdirect_isserver -%>
cat << EOF > /tmp/config.yml
roles:
- user
facilities:
- software management
- guides and templates
- interactive sessions
- object/file repositories
- passwordless SSH
clustername: <%= config.cluster %>
masterip: ""
uuid: ""
token: ""
hostname: ""
hostprefix: ""
scheduler: ""
firewallrulepath: ""
nfspaths: []
nfscustompaths: ""
gridwarepath: /opt/gridware
sessiontypes:
- gnome
storagetypes:
- posix
- s3
vpnport: ""
vpnnetwork: ""
vpnauth: ""
EOF
<% end -%>

cat << EOF > /var/lib/firstrun/scripts/flightdirect.bash
rm -rf /opt/clusterware
export cw_FLIGHT_quiet=true
mkdir -p /etc/xdg/flight
cp /tmp/config.yml /etc/xdg/flight/.
chmod +x /tmp/flight-install
/tmp/flight-install initialize
/opt/clusterware/opt/flight-configuration-tool/bin/flight-configure apply
EOF
