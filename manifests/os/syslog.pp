class bobcat::os::syslog (
  $enabled         = true,
  $log_level       = 'ERROR',
  $target_host     = undef,
  $cafile          = undef,
  $certfile        = undef,
  $keyfile         = undef,
  $queue_size      = 8192,
  $config_template = 'bobcat/os/rsyslog.conf.epp',
){

  $packages = [ 'rsyslog', 'rsyslog-gnutls' ]

  package {
    $packages:
      ensure => latest
  }
 
  file {
    "/etc/rsyslog.conf":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '644',
      content => epp($config_template),
      notify  => Service['rsyslog'];
  }
 
  service {
    'rsyslog':
      ensure => running,
      enable => $enabled;
  }

}
