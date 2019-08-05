define openvpn::server(
                        $server_name = $name,
                        $port = undef,
                        $proto = undef,
                        $local = undef,
                        $user = 'openvpn',
                        $group = 'openvpn',
                        $dev = 'tun',
                        $verbosity = '3',
                        $persist_key = false,
                        $persist_tun = false,
                        $chroot = undef,
                        $change_dir_to = undef,
                        $ping = undef,
                        $ping_restart = undef,
                        $push_ping = undef,
                        $push_ping_restart = undef,
                        $client_to_client = false,
                        $client_config_dir = undef,
                        $topology = undef,
                        $max_clients = undef,
                        $server = undef,
                        $server_netmask = '255.255.255.0',
                        $easy_rsa = true,
                        $easy_rsa_domain = 'systemadmin.es',
                        $easy_rsa_organization = 'systemadmin.es',
                        $easy_rsa_req_email = undef,
                        $easy_rsa_ca_expire = '7500',
                        $easy_rsa_cert_expire = '7500',
                        $ca_file = undef,
                        $cert_file = undef,
                        $key_file = undef,
                        $dh_file = undef,
                        $crl_verify_file = undef,
                      ) {
  exec { "mkdir base ${server_name}":
    command => "mkdir -p /etc/openvpn/server/${server_name}/",
    creates => "/etc/openvpn/server/${server_name}/",
  }

  concat { "/etc/openvpn/server/${server_name}.conf":
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  concat::fragment { "base openvpn ${server_name}":
    target  => "/etc/openvpn/server/${server_name}.conf",
    order   => '00',
    content => template("${module_name}/server.erb"),
  }

  if($easy_rsa)
  {
    # cp -r /usr/share/easy-rsa /etc/openvpn/
    exec { 'deploy easy-rsa from template':
      command => "cp -r /usr/share/easy-rsa /etc/openvpn/server/${server_name}/"
      require => Exec["mkdir base ${server_name}"],
    }

    file { '/etc/openvpn/server/${server_name}/easy-rsa/3/vars':
      ensure => 'present',
      owner => 'root',
      group => 'root',
      mode => '0755',
      content => template("${module_name}/easyrsa/vars.erb"),
    }

    
  }
  # aqui validacions de ssl related *_file

}
