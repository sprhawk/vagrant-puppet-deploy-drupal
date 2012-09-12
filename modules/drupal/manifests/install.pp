class drupal::install {
      require apache2
      require mysql
      require php5
      require drupal::extract
      require drupal::db
      require drupal::drupal_conf
      require drupal::drush

      file { "drupal-install-sh":
           path => "/var/tmp/install.sh",
           source => "puppet:///modules/drupal/install.sh",
           ensure => present,
           mode => 0644,
           owner => "vagrant",
           group => "vagrant",
      }

      exec { "install": 
           require =>  File['drupal-install-sh'],
           path => "/bin:/usr/bin:/usr/sbin",
           command => "sudo sh /var/tmp/install.sh",
           refreshonly => true,
           subscribe => File["drupal-install-sh"],
      }
}
