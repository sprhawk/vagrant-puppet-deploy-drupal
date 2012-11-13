class drupal {
      class {"drupal::extract":,} ->
      class {"drupal::drupal_conf":, } ->
      class {"drupal::db":, } -> 
      class {"drupal::install":, } -> 
      class {"drupal::modules":, } 
}
