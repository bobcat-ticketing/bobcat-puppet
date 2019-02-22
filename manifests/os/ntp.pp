class bobcat::os::ntp (
  $servers = [ 'ntp.se' ],
  $package = 'openntpd',
){

  if $package == 'openntpd' {
    package { 'ntp': ensure => purged; }
    package { 'openntpd': ensure => latest; }
    file {
      '/etc/openntpd/ntpd.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        content => epp('bobcat/os/openntpd.conf.epp'),
        notify  => Service['openntpd'];
      '/etc/default/openntpd':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        content => "DAEMON_OPTS=\"-s -f /etc/openntpd/ntpd.conf\"\n",
        notify  => Service['openntpd'];
    }
    service { 'openntpd': ensure => running, enable => true, name => 'openntpd'; }
  }

  if $package == 'ntp' {
    package { 'openntpd': ensure => purged; }
    package { 'ntp': ensure => latest; }
    file {
      '/etc/ntp.conf':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        content => epp('bobcat/os/ntp.conf.epp'),
        notify  => Service['ntp'];
      '/etc/default/ntp':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        content => "NTPD_OPTS=\"-g\"\n",
        notify  => Service['ntp'];
    }
    service { 'ntp': ensure => running, enable => true, name => 'ntp'; }
  }

}
