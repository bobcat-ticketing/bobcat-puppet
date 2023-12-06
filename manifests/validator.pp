class bobcat::validator (
  $enabled                  = true,
  $config_template          = 'bobcat/validator/validator.yaml.epp',
  $backup                   = true,
  $dynconf_enabled          = true,
  $kdk_url                  = undef,
  $dynconf_base_url         = undef,
  $dynconf_timer            = 'hourly',
  $dynconf_randomized_delay = 0,
  $dynconf_fetch_all        = true,
  $dynconf_fetch_datasets   = ["blacklists", "ticklemacros", "issuer_keyring", "participants", "products", "services", "stops"],
  $dynconf_fetch_kdk        = true,
  $python_version           = false,
  $bobcat_version           = 'latest',
  $refresh_api              = false,
  $nfc                      = false,
  $headless                 = false
){
  require bobcat
  require bobcat::facts
  require bobcat::volatilefs
  require bobcat::soundfix

  if $python_version {
    package {
      'bobcat-python':
        ensure => $python_version,
        notify => Exec['bobcat-systemctl-daemon-reload'];
    }
  }

  if $headless {
    package {
      'bobcat-validator':
        ensure => "absent";
      'bobcat-validator-headless':
        ensure => $bobcat_version,
        notify => Exec['bobcat-systemctl-daemon-reload'];
    }
  } else {
    package {
      'bobcat-validator':
        ensure => $bobcat_version,
        notify => Exec['bobcat-systemctl-daemon-reload'];
      'bobcat-validator-headless':
        ensure => "absent";
    }
  }

  if $refresh_api {
    package {
      'mosquitto-clients':
        ensure => latest;
    }
  }

  if $nfc {
    package {
      'pcscd':
        ensure => latest;
    }
  }

  if $kdk_url {
    file {
      '/usr/local/bin/kdk_update':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0544',
        backup  => $backup,
        content => epp('bobcat/validator/kdk_update.sh.epp');
    }
  } else {
    file {
      '/usr/local/bin/kdk_update':
        ensure  => absent;
    }
  }

  if $dynconf_base_url {
    file {
      '/usr/local/bin/dynconf_update':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0544',
        backup  => $backup, 
        content => epp('bobcat/validator/dynconf_update.sh.epp');
    }
    } else {
      file {
        '/usr/local/bin/dynconf_update':
          ensure  => absent;
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
      content => epp($config_template),
      backup  => $backup, 
      notify  => Service['bobcat-validator'];

    '/etc/systemd/system/bobcat-dynconf.timer':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      backup  => $backup, 
      content => epp('bobcat/validator/bobcat-dynconf.timer.epp'),
      notify  => Exec['bobcat-systemctl-daemon-reload'];

    '/etc/systemd/system/bobcat-dynconf.service':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      backup  => $backup,
      content => epp('bobcat/validator/bobcat-dynconf.service.epp'),
      notify  => Exec['bobcat-systemctl-daemon-reload'];
  }

  exec {
    'bobcat-systemctl-daemon-reload':
      command     => '/bin/systemctl daemon-reload',
      refreshonly => true,
      notify      => Service['bobcat-validator'];
  }

  service {
    'bobcat-validator':
      ensure => running,
      enable => $enabled;

    'bobcat-dynconf.timer':
      ensure => running,
      enable => $dynconf_enabled;

    'bobcat-dynconf.service':
      enable => $dynconf_enabled;
  }
}
