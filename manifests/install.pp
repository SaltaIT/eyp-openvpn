# == Class: openvpn
#
# === openvpn::install documentation
#
class openvpn::install inherits openvpn {

  if($openvpn::manage_package)
  {
    # package here, for example: 
    #package { $openvpn::params::package_name:
    #  ensure => $openvpn::package_ensure,
    #}
  }

}
