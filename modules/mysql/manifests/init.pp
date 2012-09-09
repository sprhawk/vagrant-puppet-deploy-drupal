class mysql {
      package { "mysql-client-5.1":
              ensure => present,
      }
      package { "mysql-server-5.1":
              ensure => present,
      }
}