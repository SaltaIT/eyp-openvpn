# client
# dev tun
#
# comp-lzo
# proto tcp
#
# persist-key
# persist-tun
#
# remote vpn.systemadmin.es 1184
#
# tls-client
#
# ns-cert-type server
#
# <ca>
# ...
# </ca>
#
# <cert>
# ...
# </cert>
#
# <key>
# ...
# </key>
define openvpn::client(
                        $client_name = $name,
                      ) {
  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  include ::openvpn

  exec { "mkdir base ${client_name}":
    command => "mkdir -p /etc/openvpn/client/${client_name}/",
    creates => "/etc/openvpn/client/${client_name}/",
    require => Class['::openvpn'],
  }

  # ...

  openvpn::client::service { "${openvpn::params::systemd_client_template_service}@${server_name}":
    manage_service        => $manage_service,
    manage_docker_service => $manage_docker_service,
    service_ensure        => $service_ensure,
    service_enable        => $service_enable,
  }
}
