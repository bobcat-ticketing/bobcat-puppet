class bobcat::os::rng {
  $packages = [ 'rng-tools5' ]
  package { $packages: ensure => latest }
}
