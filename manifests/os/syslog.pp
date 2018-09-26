class bobcat::os::syslog (
  $log_level   = 'ERROR',
  $target_host = undef,
  $queue_size  = 8192,
){

  $packages = [ 'rsyslog' ]

  package {
    $packages:
      ensure => latest
  }
 
  file {
    "/etc/rsyslog.conf":
      ensure => file,
      owner => 'root',
      group => 'root',
      mode => '644',
      content => epp('bobcat/os/rsyslog.conf.epp');
  }
 
  service {
    'rsyslog':
      ensure => running,
      enable => $enabled;
  }

}
