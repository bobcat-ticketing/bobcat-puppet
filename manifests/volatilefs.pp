class bobcat::volatilefs (
  $enabled      = true,
  $interface    = "eth0",
  $init_command = undef,
){
  $volatilefs_packages = [ 'cryptsetup', 'ethtool' ]
  package {
    $volatilefs_packages:
      ensure => latest;
  }

  file {
    '/usr/local/bin/volatilefs':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0544',
      require => Package['ethtool'],
      content => epp('bobcat/volatilefs.sh.epp');

    '/etc/systemd/system/volatilefs.service':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0544',
      source  => 'puppet:///modules/bobcat/volatilefs.service',
      notify  => Exec['volatilefs-systemctl-daemon-reload'];
  }

  exec {
    'volatilefs-systemctl-daemon-reload':
      command     => '/bin/systemctl daemon-reload',
      refreshonly => true;
  }

  service {
    'volatilefs':
      enable => $enabled;
  }
}
