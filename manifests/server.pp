define openvpn::server(
                        $server_name = $name,
                      ) {
  file { '/etc/openvpn/server/${server_name}.conf':
    ensure => 'present',
    owner => 'root',
    group => 'root',
    mode => '0644',
    content => template("${module_name}/server.erb"),
  }

  
}
