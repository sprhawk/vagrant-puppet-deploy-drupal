class drupal::db {
     require mysql
      exec { "db":
           path => "/usr/bin",
           command => "mysql -uroot -e 'create database if not exists drupal'",
           unless => "mysql -uroot drupal",
      }
      exec { "user":
           path => "/usr/bin",
           command => "mysql -uroot -e 'create user \"drupal\"@\"localhost\" identified by \"drupal\";'",
           unless => "mysql -udrupal -pdrupal -e ''",
           before => Exec["grant privileges"],
      }
      exec { "grant privileges":
           path => "/usr/bin", 
           command => "mysql -uroot  -e 'grant select, insert, update, delete, create, drop, index, alter  on drupal.* to \"drupal\"@\"localhost\" identified by \"drupal\";'",
           require =>[ Exec["user"], Exec["db"]],
      }
}
