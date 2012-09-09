class drupal::install {
      $drupal_tarball = 'drupal-7.15.tar.gz'
      file { "drupal-install":
           path => "/var/tmp/$drupal_tarball",
           source => "puppet:///modules/drupal/drupal/$drupal_tarball",
           ensure => file,
           mode => 0644,
           owner => "vagrant",
           group => "vagrant",
      }
      file { "drupal-install-sh":
           path => "/var/tmp/install.sh",
           source => "puppet:///modules/drupal/install.sh",
           ensure => file,
           mode => 0644,
           owner => "vagrant",
           group => "vagrant",
      }
      exec { "extract": 
           require => [File['drupal-install'], File['drupal-install-sh']],
           path => "/bin:/usr/bin:/usr/sbin",
           command => "sh /var/tmp/install.sh /var/tmp/$drupal_tarball",
      }
}
