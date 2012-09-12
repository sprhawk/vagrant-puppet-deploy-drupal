class drupal {
      include drupal::extract
      include drupal::drupal_conf
      include drupal::db
      include drupal::install
      include drupal::modules
}
