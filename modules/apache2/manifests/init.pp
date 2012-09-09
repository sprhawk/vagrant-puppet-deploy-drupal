class apache2 {
#    exec { 'apt-get update':
#        command => '/usr/bin/apt-get update'
#    }
    package { "apache2":
        ensure => present,
    }
    service { "apache2":
        ensure => running,
        require => Package["apache2"],
    }
}

