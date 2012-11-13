class drupal::extract{
      $drupal_tarball = 'drupal-7.17.tar.gz'
      file { "drupal-tarball":
           path => "/var/tmp/$drupal_tarball",
           source => "puppet:///modules/drupal/drupal/$drupal_tarball",
           ensure => present,
           mode => 0644,
           owner => "vagrant",
           group => "vagrant",
      }
      file { "drupal-extract-sh":
           path => "/var/tmp/extract.sh",
           source => "puppet:///modules/drupal/extract.sh",
           ensure => present,
           mode => 0644,
           owner => "vagrant",
           group => "vagrant",
      }

      exec { "extract": 
           #creates => "/var/www/drupal",
           creates => "/home/vagrant/drupal",
           require => [File['drupal-tarball'], File['drupal-extract-sh']],
           path => "/bin:/usr/bin:/usr/sbin",
           command => "sh /var/tmp/extract.sh /var/tmp/$drupal_tarball",
           refreshonly => true,
           subscribe => [File["drupal-extract-sh"], File["drupal-tarball"]],
      }
}
