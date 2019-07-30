class openvpn::install inherits openvpn {

  if($openvpn::manage_package)
  {
    package { $openvpn::params::package_name:
      ensure => $openvpn::package_ensure,
    }
  }

}
