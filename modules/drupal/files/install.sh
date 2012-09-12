#!/bin/bash

DRUPAL_DIR=/var/www/drupal
 
drush site-install --db-url=mysql://drupal:drupal@localhost/drupal --root=$DRUPAL_DIR --account-name=admin --account-pass=admin --account-mail="admin@nobody.me" --site-name="Nobody" --site-mail="admin@nobody.me" --yes

