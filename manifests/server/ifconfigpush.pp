define openvpn::server::ifconfigpush(
                                      $server_name,
                                      $ipaddr,
                                      $ccd     = 'ccd',
                                      $fqdn    = $name,
                                      $ensure  = 'present',
                                      $netmask = '255.255.255.0',
                                      $order   = '00',
                                    ) {
  include ::openvpn

  if(!defined(Concat["${openvpn::params::server_conf_dir}/${server_name}/${ccd}/${fqdn}"]))
  {
    concat { "${openvpn::params::server_conf_dir}/${server_name}/${ccd}/${fqdn}":
      ensure => $ensure,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      notify => Openvpn::Server::Service["openvpn-server@${server_name}"],
    }
  }

  if($ensure=='present')
  {
    concat::fragment { "ifconfig push ${server_name} ${ccd} ${fqdn}":
      target  => "${openvpn::params::server_conf_dir}/${server_name}/${ccd}/${fqdn}",
      order   => $order,
      content => template("${module_name}/server.erb"),
    }
  }
}
