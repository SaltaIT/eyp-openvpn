class openvpn::params {

  $package_name=[ 'openvpn', 'easy-rsa' ]
  $service_name='openvpn'

  case $::osfamily
  {
    'redhat':
    {
      case $::operatingsystemrelease
      {
        /^7.*$/:
        {
          $include_epel=true
          $client_conf_dir='/etc/openvpn/client'
          $server_conf_dir='/etc/openvpn/server'
          $systemd_server_template_service='openvpn-server'
          $systemd_client_template_service='openvpn-client'
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
