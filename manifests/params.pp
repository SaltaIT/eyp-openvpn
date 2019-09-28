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
    'Debian':
    {
      $include_epel=false
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^1[68].*$/:
            {
              fail('Currently unsupported')
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian':
        {
          case $::operatingsystemrelease
          {
            /^10.*$/:
            {
              $client_conf_dir='/etc/openvpn/client'
              $server_conf_dir='/etc/openvpn/server'
              $systemd_server_template_service='openvpn-server'
              $systemd_client_template_service='openvpn-client'
            }
            default: { fail("Unsupported Debian version! - ${::operatingsystemrelease}")  }
          }
        }
        default: { fail("Unsupported Debian flavour! - ${::operatingsystem}")  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
