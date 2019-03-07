class bobcat (
  $puppet_ssl = "/etc/puppet/ssl"
){

  $extra_packages = [ 'curl' ]
  package {
    $extra_packages:
      ensure => latest;
  }

  file {
    '/etc/bobcat':
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0755';

    '/etc/bobcat/host.crt':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      source  => "${puppet_ssl}/certs/${::clientcert}.pem",
      require => File['/etc/bobcat'];

    '/etc/bobcat/host.key':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      source  => "${puppet_ssl}/private_keys/${::clientcert}.pem",
      require => File['/etc/bobcat'];

    '/etc/bobcat/ca.crt':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      source  => "${puppet_ssl}/certs/ca.pem",
      require => File['/etc/bobcat'];
  }

}
