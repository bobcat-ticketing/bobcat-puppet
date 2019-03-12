class bobcat::soundfix (
  $enabled = true,
){
  file {
    '/usr/local/bin/soundfix':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0544',
      source  => 'puppet:///modules/bobcat/soundfix.sh';

    '/etc/systemd/system/soundfix.service':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      source  => 'puppet:///modules/bobcat/soundfix.service',
      notify  => Exec['soundfix-systemctl-daemon-reload'];
  }

  exec {
    'soundfix-systemctl-daemon-reload':
      command     => '/bin/systemctl daemon-reload',
      refreshonly => true;
  }

  service {
    'soundfix':
      enable => $enabled;
  }
}
