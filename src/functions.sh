#!/bin/bash

function gdt_msg_error () {
    echo -e "\033[31m [ERROR] $1 \033[0m"
}

function gdt_msg_info () {
    echo -e "\033[33m [INFO] $1 \033[0m"
}

function gdt_msg_success () {
    echo -e "\033[32m [SUCCESS] $1 \033[0m"
}

function gdt_validate_arguments() {
    DIR=$1
    TAG=$2

    # error-check: what if the folder doesn't exist
    if [ ! -d $DIR ]; then
        gdt_msg_error "The given directory [$DIR] does not exist"
        return 1
    fi

    echo "$DIR"

        cd "$DIR"

    HAS_TAG=$(git tag -l | grep $TAG)
    if [ -z "$HAS_TAG" ]; then
        gdt_msg_error "The given tag [$TAG] does not exst"
        return 1
    fi
    return 0
}

function gdt_navigate_to_docroot() {

    # if a web directory exists, navigate to it
    if [ -d "$DIR/web" ]; then
        cd "$DIR/web"
        return 0
    fi

    # if a web directory exists, navigate to it
    if [ -d "$DIR/src" ]; then
        cd "$DIR/src"
        return 0
    fi
}

function gdt_get_drush() {
    DIR=$(pwd)
    if [ -n "$1" ]; then
        echo 'here'
        DIR=$1
    fi

    DRUSH=$(which drush)
    cd $DIR
    if [ -f "$DIR/../vendor/bin/drush" ]; then
        DRUSH="$DIR/../vendor/bin/drush"
        return 0
    fi

    if [ -f "$DIR/vendor/bin/drush" ]; then
        DRUSH="$DIR/vendor/bin/drush"
        return 0
    fi
}

function gdt_deploy_drupal7() {
    DIR=$1
    TAG=$2
    ROOT=$(pwd)

    gdt_validate_arguments $DIR $TAG

    cd $DIR
    git fetch --all
    git checkout $TAG

    gdt_navigate_to_docroot $DIR

    DRUSH=$(gdt_get_drush)

    sudo su -s /bin/sh apache -c "$DRUSH updb && $DRUSH cc all"

    cd $ROOT
}


function gdt_deploy_drupal8() {
    DIR=$1
    TAG=$2
    ROOT=$(pwd)

    gdt_validate_arguments $DIR $TAG

    cd $DIR
    git fetch --all
    git checkout $TAG

    gdt_navigate_to_docroot $DIR

    DRUSH=$(gdt_get_drush)

    sudo su -s /bin/sh apache -c "$DRUSH updb && $DRUSH cr all"

    cd $ROOT
}
