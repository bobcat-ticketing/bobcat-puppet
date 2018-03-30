class bobcat::network::ntp (
  $configure = false,
  $servers   = [ 'ntp.se' ]
){

  package {
    'openntpd':
      ensure => latest;
  }

  file {
    '/etc/openntpd/ntpd.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      content => epp('bobcat/network/ntpd.conf.epp'),
      notify  => Service['openntpd'];
  }

  service {
    'openntpd':
      ensure => running,
      enable => true,
      name   => 'openntpd';
  }

}
