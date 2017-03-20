#!/bin/bash
set -eu

function github_download
{
    OWNER=$1
    REPO=$2
    VERSION=$3
    if [[ ! -f "$REPO.tar.gz" ]]; then
        wget https://github.com/$OWNER/$REPO/archive/$VERSION.tar.gz -O $REPO.tar.gz
    fi
    if [[ "$REPO-$VERSION/" -ot "REPO.tar.gz" ]]; then
        tar xvzf $REPO.tar.gz 
    fi
}

function build_autotools
{
    pushd $1
    # TODO: What does this do?
    cp --update {.,}configsbox.h
    if [[ Makefile.am -ot configure ]]; then
        ./configure
        make 
    fi
    popd
}

VERSION="a131424b6cb577e1c916bd0e8ffb2084a5f73048"
github_download tsgates mbox "$VERSION"
build_autotools "mbox-$VERSION/src"
MBOX="mbox-$VERSION/src/mbox"

$MBOX -i $@
