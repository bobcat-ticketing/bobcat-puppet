class bobcat {

  include bobcat::facts
  
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
      source  => "/etc/puppet/ssl/certs/${::fqdn}.pem",
      require => File['/etc/bobcat'];

    '/etc/bobcat/host.key':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      source  => "/etc/puppet/ssl/private_keys/${::fqdn}.pem",
      require => File['/etc/bobcat'];
  }

}
