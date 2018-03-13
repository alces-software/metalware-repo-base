<%
# Sort plugins by `priority` config value, with plugins with a lower value for
# `priority` appearing first.  Plugins without `priority` set will default to a
# priority of 9999, i.e. will probably be last unless a plugin has a priority
# explicitly set to more than this.
default_priority = 9999
prioritized_plugins = node.plugins.sort_by do |plugin|
  plugin.config.priority || default_priority
end
%>
echo "Running main.sh on <%= node.name %> at $(date)!"


export CORE_DIR=/var/lib/metalware/rendered/local/files/repo/core/
#mkdir -p "$CORE_DIR"

run_script() {
  bash "$CORE_DIR/$1.sh"
}
export -f run_script

install_file() {
  cp "$CORE_DIR/$1" "$2"
}
export -f install_file

echo

echo 'Setting root password'
usermod --password '<%= config.encrypted_root_password %>' root

echo 'Running platform setup scripts:'
if [ $(ls $CORE_DIR/../platform |wc -l) != 0 ] ; then
  for script in $CORE_DIR/../platform/* ; do
    bash $script
  done
fi

echo 'Running user setup scripts:'
if [ $(ls $CORE_DIR/../setup |wc -l) != 0 ] ; then
  for script in $CORE_DIR/../setup/* ; do
    bash $script
  done
fi

<% prioritized_plugins.each do |plugin| %>
echo 'Running setup scripts for plugin `<%= plugin.name %>`:'
  <% (plugin.files.setup || []).each do |script| %>
    <% if script.error %>
echo '<%= script.name %>: <%= script.error %>'
    <% else %>
bash "<%= script.rendered_path %>"
    <% end %>
  <% end %>
<% end %>

echo 'Running core setup scripts:'
run_script base
run_script networking

echo 'Running user scripts:'
if [ $(ls $CORE_DIR/../scripts |wc -l) != 0 ] ; then
  for script in $CORE_DIR/../scripts/* ; do
    bash $script
  done
fi

<% prioritized_plugins.each do |plugin| %>
echo 'Running scripts for plugin `<%= plugin.name %>`:'
  <% (plugin.files.scripts || []).each do |script| %>
    <% if script.error %>
echo '<%= script.name %>: <%= script.error %>'
    <% else %>
bash "<%= script.rendered_path %>"
    <% end %>
  <% end %>
<% end %>
