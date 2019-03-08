class bobcat::os::pki (
  $ca_name   = "Puppet CA",
  $ca_source = "file:///etc/puppet/ssl/certs/ca.pem"
){
  require ca_cert  # https://forge.puppet.com/pcfens/ca_cert

  ca_cert::ca {
    $ca_name:
      ensure => 'trusted',
      source => "${ca_source}";
  }
}
