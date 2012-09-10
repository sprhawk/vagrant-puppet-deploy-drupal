class drupal {
      require php5
      include drupal::drupal_conf
      include drupal::install
      include drupal::db
      include drupal::modules
      include apache2
      service {"drupal-apache2":
	ensure => running,
      }
}
