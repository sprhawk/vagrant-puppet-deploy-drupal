class drupal::drush {
    file { "install-drush.sh":
        path => "/var/tmp/install-drush.sh",
        source => "puppet:///modules/drupal/install-drush.sh",
        ensure => file,
        mode => 0644,
        owner => vagrant,
        group => vagrant,
    }
    exec { "install drush" :
        require => [File["install-drush.sh"], Package["php-pear"]],
        path => "/bin:/usr/bin",
        command => "sudo sh /var/tmp/install-drush.sh",
        unless => "pear info drush/drush",
    }
}
