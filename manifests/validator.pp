class bobcat::validator (
  $enabled          = true,
  $config_template  = 'bobcat/validator/validator.yaml.epp',
  $kdk_url          = undef,
  $dynconf_base_url = undef,
  $dynconf_timer    = 'hourly',
){
  include bobcat::volatilefs
  include bobcat::soundfix

  package {
    'bobcat-validator':
      ensure => latest;
  }

  if $kdk_url {
    file {
      '/usr/local/bin/kdk_update':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0544',
        content => epp('bobcat/validator/kdk_update.sh.epp');
    }
  }

  if $dynconf_base_url {
    file {
      '/usr/local/bin/dynconf_update':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0544',
        content => epp('bobcat/validator/dynconf_update.sh.epp');
    }
  }

  file {
    '/var/lib/bobcat':
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0755';

    '/var/lib/bobcat/dynamic':
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0755';

    '/etc/bobcat/validator.yaml':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      content => epp($config_template);

    '/etc/systemd/system/bobcat-dynconf.timer':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0544',
      content => epp('bobcat/validator/bobcat-dynconf.timer.epp'),
      notify  => Exec['bobcat-systemctl-daemon-reload'];

    '/etc/systemd/system/bobcat-dynconf.service':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0544',
      content => epp('bobcat/validator/bobcat-dynconf.service.epp'),
      notify  => Exec['bobcat-systemctl-daemon-reload'];
  }

  exec {
    'bobcat-systemctl-daemon-reload':
      command     => '/bin/systemctl daemon-reload',
      refreshonly => true;
  }

  service {
    'bobcat-validator':
      ensure => running,
      enable => $enabled;

    'bobcat-dynconf':
      enable => $enabled;
  }
}
