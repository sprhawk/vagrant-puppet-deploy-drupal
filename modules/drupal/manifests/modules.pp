# modules: og, og_views, entity, views, ctools, panels

class drupal::modules {

      $drupal_source_path = "puppet:///modules/drupal/drupal"
      $drupal_temp_path = "/var/tmp"
      $drupal_site_root_path = "/var/www/drupal"
      
      $libraries_source_path = "$drupal_source_path/libs"
      $libraries_temp_path = "$drupal_temp_path"
      $libraries_install_path = "$drupal_site_root_path/sites/all/libraries"
      define library($file, $path="/bin:/usr/bin", $command) {
      
            $source_path = "$libraries_source_path/$file"
            $temp_path = "$libraries_temp_path/$file"
            #$install_path = "$libraries_install_path/$file"
            file { $file:
                 path => $temp_path,
                 source => $source_path,
                 ensure => present,
                 owner => vagrant,
                 group => vagrant,
            }
            exec { "install-drupal-library-$name":
                 path => $path,
                 command => $command,
                 #refreshonly => true,
                 subscribe => File[$file],
            }
      }
      
      $modules_source_path = "$drupal_source_path/modules"
      $modules_temp_path = "$drupal_temp_path"
      $modules_install_path = "$drupal_site_root_path/sites/all/modules"
      define module($file) { # should supply a alternative path/command parameter
      
            $source_path = "$modules_source_path/$file"
            $temp_path = "$modules_temp_path/$file"
            #$install_path = "$modules_install_path"
      
            file { $file:
                 path => $temp_path,
                 source => $source_path,
                 ensure => present,
                 owner => "vagrant",
                 group => "vagrant",
            }
            exec { "install-drupal-modules-$name": #why $module goes wrong?
                 #require => File[$file],
                 path => "/bin:/usr/bin",
                 command => "/bin/sh -c 'cd $modules_install_path; sudo tar xvf $temp_path; sudo chown -R www-data:www-data $name; chmod ug+w -R $name'",
                 #refreshonly => true,
                 subscribe => File[$file],
            }
      }
      require drupal::install
      Module {before => Exec["enable modules"]}
      module {"og": file=>"og-7.x-1.4.tar.gz"}
      module {"og_views": file=>"og_views-7.x-1.0.tar.gz"}
      module {"panels": file=>"panels-7.x-3.2.tar.gz"}
      module {"entity": file=>"entity-7.x-1.0-rc3.tar.gz"}
      module {"views": file=>"views-7.x-3.3.tar.gz"}
      module {"ctools": file=>"ctools-7.x-1.0.tar.gz"}
      module {"features": file=>"features-7.x-1.0.tar.gz"}
      module {"role_export": file=>"role_export-7.x-1.0.tar.gz"}
      module {"services": file=>"services-7.x-3.1.tar.gz"}
      module {"oauth": file=>"oauth-7.x-3.0.tar.gz"}
      module {"wysiwyg": file=>"wysiwyg-7.x-2.1.tar.gz"}
      #module {"flowplayer": file=>"flowplayer-7.x-1.0-alpha1.tar.gz"}
      #module {"file_entity": file=>"file_entity-7.x-2.0-unstable6.tar.gz"}
      module {"media": file=>"media-7.x-1.2.tar.gz"}
      #module {"plupload": file=>"plupload-7.x-1.0.tar.gz"}
      module {"libraries": file=>"libraries-7.x-2.0.tar.gz"}
      module {"mediaelement": file=>"mediaelement-7.x-1.2.tar.gz", require=>Module["libraries"],}

      file {$libraries_install_path:
        ensure => directory,
        owner => "www-data",
        group => "www-data",
      }

      $spyc="spyc-0.5"
      library { "$spyc":
        file => "$spyc.zip",
        command => "sh -c \"cd $modules_install_path/services/servers/rest_server/lib; unzip -j $libraries_temp_path/$file $spyc/spyc.php; chown www-data:www-data spyc.php\"",
        subscribe=>Module["services"],
        require => File[$libraries_install_path],
      }

      $ckeditor = "ckeditor"
      $ckeditor_file = "$ckeditor_3.6.4.tar.gz"
      library { "$ckeditor":
        require => Module["wysiwg"],
        file => "$ckeditor_file",
        command => "cd $libraries_install_path; tar xvf $libraries_temp_path/$ckeditor_file; chown -R www-data:www-data $ckeditor;",
      }
      #$markitup = "markitup"
      #$markitup_file = "markitup-pack-1.1.13.zip"
      #library { "$markitup":
      #  file => $markitup_file, #unzip cannot get $file properly
      #  command => "sh -c \"cd $libraries_temp_path; mkdir \\\"$markitup\\\"; unzip $markitup_file -d \\\"$markitup\\\"; mkdir -p $libraries_install_path/; rm -rf $libraries_install_path/markitup; mv -f \\\"$markitup/latest\\\" $libraries_install_path/markitup ; rm -rf \\\"$markitup\\\"; chown -R www-data:www-data $libraries_install_path/markitup;\" ",
      #  subscribe => Module["wysiwyg"],
      #  require => File[$libraries_install_path],
      #}
      exec { "enable modules":
	path => "/bin:/usr/bin",
	command => "drush -r $drupal_site_root_path -y pm-enable ctools entity views views_ui panels panels_node page_manager views_content panels_ipe panels_mini og og_access og_context og_field_access og_ui og_views features role_export services rest_server services_oauth oauth_common oauth_common_providerui wysiwyg file_entity media media_internet libraries mediaelement",
      }
      exec { "rebuild permissions":
	require => Exec["enable modules"],
	path => "/bin:/usr/bin",
	command => "drush -r $drupal_site_root_path -y php-eval 'node_access_rebuild();'",
      } 
}

