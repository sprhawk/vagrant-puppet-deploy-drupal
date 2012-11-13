#!/bin/bash
set -o nounset

DRUPAL_DIR=/home/vagrant/drupal
#DRUPAL_DIR=/var/www/drupal
 
drush site-install --db-url=mysql://drupal:drupal@localhost/drupal --root=$DRUPAL_DIR --account-name=admin --account-pass=admin --account-mail="admin@nobody.me" --site-name="Nobody" --site-mail="admin@nobody.me" --yes
chown -R www-data:www-data $DRUPAL_DIR/sites/default/settings.php
# for example, sites/default/files is created as root, should be changed owner to www-data
chown -R www-data:www-data $DRUPAL_DIR
#chmod 666 $DRUPAL_DIR/sites/default/settings.php

# to supress warning message
sh -c "echo \"\\\$conf['drupal_http_request_fails'] = FALSE;\" >> $DRUPAL_DIR/sites/default/settings.php"
