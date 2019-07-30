class openvpn::service inherits openvpn {

  #
  validate_bool($openvpn::manage_docker_service)
  validate_bool($openvpn::manage_service)
  validate_bool($openvpn::service_enable)

  validate_re($openvpn::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${openvpn::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $openvpn::manage_docker_service)
  {
    if($openvpn::manage_service)
    {
      service { $openvpn::params::service_name:
        ensure => $openvpn::service_ensure,
        enable => $openvpn::service_enable,
      }
    }
  }
}
