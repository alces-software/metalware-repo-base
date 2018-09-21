#!/bin/bash
<% if node.answer.metalware_internal--plugin_enabled--ipa -%>
ssh infra01 "echo <%= node.plugins.ipa.config.ipa_securepassword %> |kinit admin && ipa host-disable <%= node.config.networks.pri.hostname %> && ipa host-mod <%= node.config.networks.pri.hostname %> --password='<%= node.plugins.ipa.config.ipa_insecurepassword %>'"
<% end -%>
