### LOCALISED INSTALL NOTES ###
#
## Create flightdirect export on controller
#mkdir -p /opt/alces/installers/flightdirect
#cd /opt/alces/installers/flightdirect
#
## Download flight-install and flight-configure (change 1.0.4 to latest version)
#wget https://s3-eu-west-1.amazonaws.com/alces-flight/FlightDirect/1.0.4/flight-install
#wget https://s3-eu-west-1.amazonaws.com/alces-flight/FlightDirect/1.0.4/flight-configure
#
## Download the clusterware installer
#
## Clone the S3 dist bucket
#
## Do some wizardry with clusterware-services to create a tarball
#
### END ###

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
#export cw_BUILD_flight_configure_url=http://10.10.0.1/installers/flightdirect/flight-configure
#export cw_BUILD_installer_url=
#export cw_BUILD_dist_url=http://10.10.0.1/installers/flightdirect/dist
#export cw_BUILD_source_url=http://10.10.0.1/installers/flightdirect/clusterware.tar.gz
#export cw_BUILD_repos_url=http://10.10.0.1/installers/flightdirect/repos

rm -rf /opt/clusterware
export cw_FLIGHT_quiet=true
mkdir -p /etc/xdg/flight
cp /tmp/config.yml /etc/xdg/flight/.
chmod +x /tmp/flight-install
/tmp/flight-install initialize
/opt/clusterware/opt/flight-configuration-tool/bin/flight-configure apply
EOF
