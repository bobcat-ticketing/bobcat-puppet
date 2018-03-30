class bobcat::network::interfaces (
  $configure   = false,
  $device      = "eth0",
  $address     = "192.168.1.2",
  $netmask     = "255.255.255.0",
  $gateway     = "192.168.1.1",
  $nameservers = [],
) {

  if $configure {
    package {
      'resolvconf':
        ensure => latest;
    }

    file {
      "/etc/network/interfaces":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        content => epp('bobcat/network/interfaces.epp');
    }
  }

}
