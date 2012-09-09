class php5 {
      package {"php5":
              ensure => present,
      }
      package {"php5-mysql":
              require => Package[php5],
              ensure => present,
      }
}