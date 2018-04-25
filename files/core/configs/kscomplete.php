<?php
$cmd="mkdir -p /var/lib/metalware/events/{$_GET['name']} && echo {$_GET['msg']} > /var/lib/metalware/events/{$_GET['name']}/{$_GET['event']}";
exec($cmd);
?>
