# modules: og, og_views, entity, views, ctools, panels
define module($name) {
      $module_source_path = "puppet:///modules/drupal/drupal"
      file { $name:
           path => "/var/tmp/$name",
           source => "$module_source_path/$name",
           ensure => present,
           owner => vagrant,
           group => vagrant,
      }
      exec { "install-drupal-modules-$name":
           require => File[$name],
           path => "/bin:/usr/bin",
           command => "/bin/sh -c 'cd /var/www/drupal/sites/all/modules; sudo tar xvf /var/tmp/$name; sudo chown -R www-data:www-data $title'",
           refreshonly => true,
           subscribe => File[$name],
      }
}

class drupal::modules {
      require drupal::install
      Module {before => Exec["enable modules"]}
      module {"og": name=>"og-7.x-1.4.tar.gz"}
      module {"og_views": name=>"og_views-7.x-1.0.tar.gz"}
      module {"panels": name=>"panels-7.x-3.2.tar.gz"}
      module {"entity": name=>"entity-7.x-1.0-rc3.tar.gz"}
      module {"views": name=>"views-7.x-3.3.tar.gz"}
      module {"ctools": name=>"ctools-7.x-1.0.tar.gz"}
      exec { "enable modules":
	path => "/bin:/usr/bin",
	command => "drush -r /var/www/drupal -y pm-enable ctools entity views views_ui panels panels_node og og_access og_context og_field_access og_ui og_views",
      }
      exec { "rebuild permissions":
	require => Exec["enable modules"],
	path => "/bin:/usr/bin",
	command => "drush -r /var/www/drupal -y php-eval 'node_access_rebuild();'",
      } 
}

