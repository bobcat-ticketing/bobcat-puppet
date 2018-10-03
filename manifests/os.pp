class bobcat::os (
  $users = [],
  $ssh_authorized_keys = [],
){
  include ::bobcat::os::ntp
  include ::bobcat::os::syslog
  include ::bobcat::os::pki

  create_resources(user, $users, { ensure => present })
  create_resources(ssh_authorized_key, $ssh_authorized_keys, { ensure => present })
}
