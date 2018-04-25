<%     config.firewall.each do |zone, info| -%>
<%     next if zone.to_s == 'enabled' -%>
# Create zone
firewall-cmd --info-zone=<%= zone %> >> /dev/null
if [ $? != 0 ] ; then
    firewall-cmd --new-zone <%= zone %> --permanent
fi
# Add services
<%         info.services.split(' ').each do |service| -%>
firewall-cmd --add-service <%= service %> --zone <%= zone %> --permanent
<%         end -%>

<%     end -%>

# Add interfaces to zones
<%     config.networks.each do |network, info| -%>
<%         if info.defined  && info.firewallpolicy -%>
firewall-cmd --add-interface <%= info.interface %> --zone <%= info.firewallpolicy %> --permanent
<%         end -%>
<%     end -%>
firewall-cmd --reload
