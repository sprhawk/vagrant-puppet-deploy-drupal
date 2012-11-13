class drupal::drupal_conf {
    require apache2

    $apache2_conf_dir = "/etc/apache2"
    file { "drupal.conf" :
         path => "$apache2_conf_dir/sites-available/drupal.conf",
         source => "puppet:///modules/drupal/drupal.conf",
         ensure => file,
         mode => 0644,
         owner => root,
    }
    file { "remove 000-default":
	path => "$apache2_conf_dir/sites-enabled/000-default",
	ensure => absent,
    }
    file { "001drupal.conf" :
         path => "$apache2_conf_dir/sites-enabled/001drupal.conf",
         ensure => link,
         target => "$apache2_conf_dir/sites-available/drupal.conf",
         owner => root,
         require => [File["drupal.conf"], File["remove 000-default"]],
    }
    file { "enable modrewrite":
         path => "$apache2_conf_dir/mods-enabled/rewrite.load",
         ensure => link,
         target => "$apache2_conf_dir/mods-available/rewrite.load",
         owner => root,
    }
    service { "apache2_drupal" :
        name => "apache2",
        subscribe => [File["001drupal.conf"], File["enable modrewrite"]],
        hasrestart => true,
        ensure => running,
    }
}

