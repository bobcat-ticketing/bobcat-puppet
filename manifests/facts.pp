class bobcat::facts (
  $xid_enable       = false,
  $xid_fact         = 'vehicle_xid',
  $xid_mqtt_broker  = '192.168.3.1',
  $xid_mqtt_version = 'mqttv31'
){
  if $xid_enable {
    package {
      'mosquitto-clients':
        ensure => latest;
    }

    file {
      '/etc/facter/facts.d/xid.sh':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0544',
        content => epp('bobcat/facts/xid.sh.epp');
    }
  } else {
      file {
        '/etc/facter/facts.d/xid.sh':
          ensure  => absent;
    }
  }
}
