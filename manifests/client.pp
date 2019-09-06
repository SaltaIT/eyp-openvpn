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
                        $client_name           = $name,
                        $remote                = $name,
                        $remote_port           = '1184',
                        $manage_service        = true,
                        $manage_docker_service = true,
                        $service_ensure        = 'running',
                        $service_enable        = true,
                        $dev                   = 'tun1',
                        $proto                 = undef,
                        $persist_key           = false,
                        $persist_tun           = false,
                      ) {
  # Exec {
  #   path => '/usr/sbin:/usr/bin:/sbin:/bin',
  # }

  include ::openvpn

  # exec { "mkdir base ${client_name}":
  #   command => "mkdir -p ${openvpn::params::client_conf_dir}/${client_name}/",
  #   creates => "${openvpn::params::client_conf_dir}/${client_name}/",
  #   require => Class['::openvpn'],
  # }

  # ...

  openvpn::client::service { "${openvpn::params::systemd_client_template_service}@${client_name}":
    manage_service        => $manage_service,
    manage_docker_service => $manage_docker_service,
    service_ensure        => $service_ensure,
    service_enable        => $service_enable,
  }
}
