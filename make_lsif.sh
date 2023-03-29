#!/bin/bash
# This script expects next packages installed:
# python3 curl unzip git libgmp-dev libc6-dev make python3-pip python3-venv
set -e

DIR=`mktemp -d`
[ -d ~/.config/alire/indexes/als ] && rm -rf ~/.config/alire/indexes/als

if ! type alr 2> /dev/null ; then
    URL=https://github.com/alire-project/alire/releases/download
    curl -o $DIR/alr.zip -L $URL/v1.2.2/alr-1.2.2-bin-x86_64-linux.zip
    unzip $DIR/alr.zip -d $DIR
    export PATH=$DIR/bin:$PATH
    cp -v $DIR/bin/alr .
    alr -n toolchain --select gnat_native gprbuild
fi

git -C $DIR clone https://github.com/reznikmm/als-alire-index.git
alr -n index --add file://$DIR/als-alire-index --name als

pushd $DIR
export LIBRARY_TYPE=static
alr -n -q get lsif_ada
cd lsif_ada*
alr -n -q build -- -gnatwn
popd

alr -n index --del als
cp -f -v $DIR/lsif_ada*/bin/lsif-ada .
rm -rf $DIR
