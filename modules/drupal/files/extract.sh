#!/bin/bash

DRUPAL_DIR=/var/www/drupal
TMP_DIR=/var/tmp/drupal

#if [[ -z $1 ]]; then
#    echo "$0: $0 drupal-xx.xx.tar.gz"
#    exit 1
#fi
#

if [ $# -lt 1 ]; then
    echo "usage:$0 drupal-xx.xx.tar.gz"
    exit 1
fi

if [ -d $DRUPAL_DIR ]
    then
    rm -rf $DRUPAL_DIR
fi

if [ ! -d $TMP_DIR ]
    then
    mkdir -p $TMP_DIR
fi

echo "Extracting $1 into $TMP_DIR"

tar xvf $1 -C $TMP_DIR

for i in $TMP_DIR/drupal*; do
    mv -f $i $DRUPAL_DIR
    break
done

sudo chown -R www-data:www-data $DRUPAL_DIR
