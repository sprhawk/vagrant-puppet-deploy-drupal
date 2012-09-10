class drupal::install {
      require php5
      $drupal_tarball = 'drupal-7.15.tar.gz'
      file { "drupal-install":
           path => "/var/tmp/$drupal_tarball",
           source => "puppet:///modules/drupal/drupal/$drupal_tarball",
           ensure => present,
           mode => 0644,
           owner => "vagrant",
           group => "vagrant",
      }
      file { "drupal-install-sh":
           path => "/var/tmp/install.sh",
           source => "puppet:///modules/drupal/install.sh",
           ensure => present,
           mode => 0644,
           owner => "vagrant",
           group => "vagrant",
      }

      exec { "extract": 
           require => [File['drupal-install'], File['drupal-install-sh']],
           path => "/bin:/usr/bin:/usr/sbin",
           command => "sh /var/tmp/install.sh /var/tmp/$drupal_tarball",
           refreshonly => true,
           subscribe => File["drupal-install-sh"],
      }
}
