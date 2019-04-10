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

