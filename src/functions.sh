#!/bin/bash

function gdt_deploy_drupal7() {
    DIR=$1
    TAG=$2
    ROOT=$(cwd)

    cd $DIR
    git fetch --all
    git checkout $TAG
    sudo su -s /bin/sh apache -c "drush updb && drush cr all"

    cd $ROOT
}


function gdt_deploy_drupal8() {
    DIR=$1
    TAG=$2
    ROOT=$(cwd)

    cd $DIR
    git fetch --all
    git checkout $TAG
    sudo su -s /bin/sh apache -c "drush updb && drush cr all"

    cd $ROOT
}
