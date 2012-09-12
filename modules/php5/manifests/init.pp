class php5 {
      package {"php5":
              ensure => present,
      }
      package {["php5-mysql","php-pear",  "php5-gd"] :
              require => Package["php5"],
              ensure => present,
      }
}
