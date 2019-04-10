exec { "apt-update":
  command => "/usr/bin/apt-get update"
}

package { "mysql-server":
  ensure  => installed,
  require => Exec["apt-update"],
}

file { "/etc/mysql/conf.d/allow_external.cnf":
  owner   => mysql,
  group   => mysql,
  mode    => 0644,
  content => template("/vagrant/manifests/allow_ext.cnf"),
  require => Package["mysql-server"],
  notify  => Service["mysql"],
  #Define uma dependencia de exec: sempre que o recurso file for alterado, ele fara com que o recurso service execute
}

service { "mysql":
  ensure     => running,  # Garante que o serviço esteja rodando
  enable     => true,     # Garante que o serviçø rode sempre que o servidor reiniciar
  hasstatus  => true,     # Declara que o serviço entende o comando status
  hasrestart => true,     # Rrestart
  require    => Package["mysql-server"],
}

exec { "loja-schema":
  #Comando de teste, caso a saida seja do codigo seja 0, o comando nao executa.
  #Ao contrario do exec apt-get update, neste caso eh importante que o Puppet nao
  # tente criar um novo schema toda vez que for executado
  unless  => "mysql -u root loja_schema",
  command => "mysqladmin -u root create loja_schema",
  path    => "/usr/bin",
  require => Service["mysql"],
}

exec { "remove-anonymous-user":
  command => "mysql -u root -e \"DELETE FROM mysql.user WHERE user=''; FLUSH PRIVILEGES\"",
  onlyif  => "mysql -u ''", #Executa apenas se a saida do teste for 0
  path    => "/usr/bin",
  require => Service["mysql"],
}

exec { "loja-user":
  unless  => "mysql -u loja -p lojasecret loja_schema",
  command => "mysql -u root -e \"GRANT ALL PRIVILEGES ON loja_schema.* TO 'loja'@'%' IDENTIFIED BY 'lojasecret';\"",
  path    => "/usr/bin",
  require => Exec["loja-schema"],
}
