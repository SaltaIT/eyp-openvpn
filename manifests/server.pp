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
  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  include ::openvpn

  exec { "mkdir base ${server_name}":
    command => "mkdir -p /etc/openvpn/server/${server_name}/",
    creates => "/etc/openvpn/server/${server_name}/",
    require => Class['::openvpn'],
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
    exec { "deploy easy-rsa from template ${server_name}":
      command => "cp -r /usr/share/easy-rsa /etc/openvpn/server/${server_name}/",
      require => Exec["mkdir base ${server_name}"],
    }

    file { "/etc/openvpn/server/${server_name}/easy-rsa/3/vars":
      ensure => 'present',
      owner => 'root',
      group => 'root',
      mode => '0755',
      content => template("${module_name}/easyrsa/vars.erb"),
      require => Exec["deploy easy-rsa from template ${server_name}"],
    }

    exec { "init-pki ${server_name}":
      command => "/etc/openvpn/server/${server_name}/easy-rsa/3/easyrsa init-pki",
      cwd     => "/etc/openvpn/server/${server_name}/easy-rsa/3/",
      creates => "/etc/openvpn/server/${server_name}/easy-rsa/3/pki",
      require => File["/etc/openvpn/server/${server_name}/easy-rsa/3/vars"],
      timeout => 0,
    }

    #./easyrsa gen-dh
    exec { "gen-dh ${server_name}":
      command => "/etc/openvpn/server/${server_name}/easy-rsa/3/easyrsa gen-dh",
      cwd     => "/etc/openvpn/server/${server_name}/easy-rsa/3/",
      creates => "/etc/openvpn/server/${server_name}/easy-rsa/3/pki/dh.pem",
      require => Exec["init-pki ${server_name}"],
      timeout => 0,
    }

    exec { "build-ca ${server_name}":
      command => "/etc/openvpn/server/${server_name}/easy-rsa/3/easyrsa build-ca nopass",
      environment => [ "EASYRSA_REQ_CN=ca.${easy_rsa_domain}" ],
      cwd     => "/etc/openvpn/server/${server_name}/easy-rsa/3/",
      require => Exec["init-pki ${server_name}"],
      timeout => 0,
    }

  }
  # TODO:
  # else { aqui validacions de ssl related *_file }

}
