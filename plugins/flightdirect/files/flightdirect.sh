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
## (latest stable version, e.g. https://raw.githubusercontent.com/alces-software/clusterware/2.0.0-preview4/scripts/bootstrap)
###
### yum install s3cmd
###
### export AWS_ACCESS_KEY_ID=xxxx
### export AWS_SECRET_ACCESS_KEY=xxxx
###
### s3cmd --no-ssl get --recursive s3://packages.alces-software.com/clusterware/dist/el7 dist
###
### cd dist/el7
### rm -f gridware.tar.gz aws.tar.gz components.tar.gz modules.tar.gz git.tar.gz s3cmd.tar.gz clusterware-dropbox-cli.tar.gz alces-storage-manager-daemon.tar.gz galaxy.tar.gz alces-access-manager-daemon.tar.gz alces-flight-trigger.tar.gz
### mv components-20170117-cw1_8.tar.gz components.tar.gz
### mv git-20160615-cw1_5.tar.gz git.tar.gz
### mv gridware-20180326-cw2_0.tar.gz gridware.tar.gz
### mv modules-20161031-cw1_7.tar.gz modules.tar.gz
### mv s3cmd-20160810-cw1_6.tar.gz s3cmd.tar.gz
### mv aws-20160411-cw1_5.tar.gz aws.tar.gz
### mv clusterware-dropbox-cli-v2.0.1-cw1_9.tar.gz clusterware-dropbox-cli.tar.gz
### mv alces-storage-manager-daemon-v1.2-cw1_7.tar.gz alces-storage-manager-daemon.tar.gz
### mv alces-access-manager-daemon-20161021-cw1_7.tar.gz alces-access-manager-daemon.tar.gz
### mv galaxy-20160301-cw1_3.tar.gz galaxy.tar.gz
### mv alces-flight-trigger-20170329-cw1_8.tar.gz alces-flight-trigger.tar.gz
### rm -f components-* git-* gridware-* modules-* s3cmd-* aws-* clusterware-dropbox-cli-* alces-storage-manager-daemon-* alces-access-manager-daemon-* galaxy-* alces-flight-trigger-*
#
## Clone the dist directory
## (https://console.aws.amazon.com/s3/buckets/packages.alces-software.com/clusterware/dist/?region=eu-west-1&tab=overview)
#
## Do some wizardry with clusterware-services to create a tarball
###
### for i in clusterware-handlers clusterware-sessions clusterware-services clusterware-storage gridware-packages-main packager-base gridware-depots ; do git clone https://github.com/alces-software/$i.git /tmp/repos/$i ; done
###
### for i in clusterware-handlers clusterware-sessions clusterware-services clusterware-storage gridware-packages-main packager-base gridware-depots ; do tar --warning=no-file-changed -C /tmp/repos/$i -czf repos/$i.tar.gz . ; done
#
## Download clusterware tarball
### wget -O clusterware.tar.gz https://github.com/alces-software/clusterware/archive/master.tar.gz
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
#export cw_BUILD_installer_url=http://10.10.0.1/installers/flightdirect/bootstrap
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
