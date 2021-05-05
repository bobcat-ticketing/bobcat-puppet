class bobcat::ddisplay (
  $enabled         = true,
  $config_template = 'bobcat/ddisplay/ddisplay.yaml.epp',
  $python_version  = 'latest',
  $bobcat_version  = 'latest'
){
  require bobcat

  package {
    'bobcat-python':
      ensure => $python_version,
      notify => Exec['bobcat-ddisplay-systemctl-daemon-reload'];

    'bobcat-ddisplay':
      ensure => $bobcat_version,
      notify => Exec['bobcat-ddisplay-systemctl-daemon-reload'];
  }

  file {
    '/etc/bobcat/ddisplay.yaml':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      content => epp($config_template);
  }

  exec {
    'bobcat-ddisplay-systemctl-daemon-reload':
      command     => '/bin/systemctl daemon-reload',
      refreshonly => true,
      notify      => Service['bobcat-ddisplay'];
  }

  service {
    'bobcat-ddisplay':
      ensure => running,
      enable => $enabled;
  }
}
