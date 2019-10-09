cat << EOF > /var/lib/firstrun/scripts/flightenv.bash
yum install -y https://openflighthpc.s3-eu-west-1.amazonaws.com/repos/openflight/x86_64/openflighthpc-release-1-1.noarch.rpm
yum install -y https://alces-flight.s3-eu-west-1.amazonaws.com/repos/alces-flight/x86_64/alces-flight-release-1-1.noarch.rpm

#
# Flight Starter
#
yum -y install flight-starter

# Use Alces Flight Direct branding
yum -y swap flight-starter-banner flight-direct-flight-starter-banner

#
# Flight Environment
#
yum -y install flight-env

# Set cluster name
/opt/flight/bin/flight config set cluster.name <%= config.cluster %>

# Install VTE for srun over terminal
yum install -y vte vte-profile
EOF
