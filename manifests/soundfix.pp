class bobcat::soundfix (
  $enabled = true,
  $pcmvol = 50
){
  file {
    '/usr/local/bin/soundfix':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0544',
      content => epp('bobcat/soundfix.sh.epp');

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
