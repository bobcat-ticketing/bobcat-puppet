class bobcat::os::pki {
  require ca_cert  # https://forge.puppet.com/pcfens/ca_cert

  ca_cert::ca {
    'Puppet CA':
      ensure => 'trusted',
      source => "file://${::bobcat::puppet_ssl}/certs/ca.pem";
  }
}
