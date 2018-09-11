cat << EOF > /var/lib/firstrun/scripts/flightdirect2.bash
CACHESERVER=<%= node.plugins.flightdirect2.config.flightdirect2_cacheserver %>

<% if node.plugins.flightdirect2.config.flightdirect2_iscache -%>
# Setup cache server
curl -L https://raw.githubusercontent.com/alces-software/flight-direct/master/scripts/bootstrap.sh | bash -s <%= node.plugins.flightdirect2.config.flightdirect2_version %>

source /etc/profile
flight config set public-dir=/opt/anvil/public role=cache cache-url=http://localhost
#source /etc/profile

echo -e '<%= node.plugins.flightdirect2.config.flightdirect2_deploy_key %>' > /tmp/anvil_ssh
chmod 600 /tmp/anvil_ssh
echo "ssh-agent bash -c 'ssh-add /tmp/anvil_ssh ; git clone git@github.com:alces-software/anvil.git /opt/anvil'" |flight bash
rm -f /tmp/anvil_ssh
echo "cd /opt/anvil ; git checkout release/1.0.0 ; export ANVIL_BASE_URL=http://\$CACHESERVER ; bash ./scripts/install.sh" |flight bash
# sleep to ensure server comes up
sleep 10
flight forge install flight-syncer

# Setup genders file
cat << EOD > /opt/flight-direct/etc/genders
################################################################################
##
## Alces Clusterware - Genders configuration
## Copyright (c) 2018 Alces Software Ltd
##
################################################################################
<% groups = [] -%>
<% NodeattrInterface.nodes_in_gender('compute').each do |node| -%>
<% groups << NodeattrInterface.genders_for_node(node).first -%>
<% end -%>
<% groups = groups.uniq -%>
<% groups.uniq.each do |group| -%>
<%= NodeattrInterface.hostlist_nodes_in_gender(group) %>    <%= group %>,compute
<% end -%>
EOD

# Share genders file
flight sync cache file /opt/flight-direct/etc/genders

<% end -%>

<% if node.plugins.flightdirect2.config.flightdirect2_isserver || node.plugins.flightdirect2.config.flightdirect2_isclient -%>
curl http://\$CACHESERVER/flight-direct/bootstrap.sh | bash
source /etc/profile

<% if node.plugins.flightdirect2.config.flightdirect2_isclient -%>
ROLE=compute
<% elsif node.plugins.flightdirect2.config.flightdirect2_isserver -%>
ROLE=login
<% end -%>

flight config set role=\$ROLE clustername=<%= config.cluster %>

flight forge install flight-syncer
flight forge install flight-completion
flight forge install clusterware-gridware

<% if node.plugins.flightdirect2.config.flightdirect2_isserver -%>
flight forge install clusterware-docs
flight forge install clusterware-storage
flight forge install clusterware-sessions
flight forge install clusterware-ssh
<% end -%>

flight sync add files genders
flight sync run-sync

<% end -%>

EOF
