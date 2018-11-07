#!/bin/bash

set -e
argc=$#
arg1=$1
opengrok_storagePath=/home/Opengrok_Storage
sourcePath=$opengrok_storagePath/src
rundate=`date +%Y%m%d_%H%M`

function init()
{
    rm -rf $sourcePath
    mkdir -p $sourcePath
}

#bl1
function bl1()
{
    cd $sourcePath
    mkdir bl1
    cd bl1

    git clone http://git.nexell.co.kr:8081/gerrit/nexell/bl1/bl1-s5p4418
    git clone http://git.nexell.co.kr:8081/gerrit/nexell/bl1/bl1-s5p6818

    cd $sourcePath/bl1/bl1-s5p4418
    git checkout nexell
    cd $sourcePath/bl1/bl1-s5p6818
    git checkout nexell

    touch latest_init_time-$rundate
}

#kernel
function kernel()
{
    cd $sourcePath

    git clone http://git.nexell.co.kr:8081/gerrit/nexell/linux/kernel/kernel-4.4.19
    cd $sourcePath/kernel-4.4.19
    git checkout nexell

    touch latest_init_time-$rundate
}

#u-boot
function uboot()
{
    cd $sourcePath

    git clone http://git.nexell.co.kr:8081/gerrit/nexell/linux/u-boot/u-boot-2016.01

    cd $sourcePath/u-boot-2016.01
    git checkout nexell

    touch latest_init_time-$rundate
}


#yocto

init
bl1
kernel
uboot
#yocto()

~/scripts/docker_opengrok_restart.sh
