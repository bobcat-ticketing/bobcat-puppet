class bobcat::network (
  $configure_interfaces = false,
  $configure_resolvers = false,
  $device    = "eth0",
  $address   = "192.168.1.2",
  $netmask   = "255.255.255.0",
  $gateway   = "192.168.1.1",
  $domain    = undef,
  $nameservers = []
) {

  if $configure_interfaces {
    file {
      "/etc/network/interfaces":
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0444',
        content => epp('bobcat/network/interfaces.epp');
      }
    }

    if $configure_resolvers {
      file {
        "/etc/resolv.conf":
          ensure  => file,
          owner   => 'root',
          group   => 'root',
          mode    => '0444',
          content => epp('bobcat/network/resolv.conf.epp');
        }
      }

}
