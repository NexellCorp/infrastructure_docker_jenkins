#!/bin/bash

set -e
argc=$#
arg1=$1
opengrok_storagePath=/home/Opengrok_Storage
sourcePath=$opengrok_storagePath/src
rundate=`date +%Y%m%d_%H%M`

#bl1
function bl1()
{
    cd $sourcePath/bl1/bl1-s5p4418
    git clean -f -d;git checkout -f
    git pull --rebase
    
    cd $sourcePath/bl1/bl1-s5p6818
    git clean -f -d;git checkout -f
    git pull --rebase

    touch latest_sync_time-$rundate
}

#kernel
function kernel()
{
    cd $sourcePath/kernel-4.4.19
    git clean -f -d;git checkout -f
    git pull --rebase

    touch latest_sync_time-$rundate
}

#u-boot
function uboot()
{
    cd $sourcePath/u-boot-2016.01
    git clean -f -d;git checkout -f
    git pull --rebase

    touch latest_sync_time-$rundate
}
#yocto

init
bl1
kernel
uboot
#yocto()

~/scripts/docker_opengrok_restart.sh
