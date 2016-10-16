# == Class: openvpn
#
# === openvpn documentation
#
class openvpn(
                            $manage_package        = true,
                            $package_ensure        = 'installed',
                            $manage_service        = true,
                            $manage_docker_service = true,
                            $service_ensure        = 'running',
                            $service_enable        = true,
                          ) inherits openvpn::params{

  class { '::openvpn::install': } ->
  class { '::openvpn::config': } ~>
  class { '::openvpn::service': } ->
  Class['::openvpn']

}
