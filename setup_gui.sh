#!/bin/bash

CENTOS_HOME=/home/centos
CENTOS_PWD=temp_pwd_
CENTOS_PWD+=$((RANDOM%1000))

pushd $CENTOS_HOME

function setup_password {
    info_msg "Setting password for user 'centos'"
    echo "centos:$CENTOS_PWD" | sudo chpasswd

    info_msg "**************************************"
    info_msg "*** PASSWORD : ${CENTOS_PWD}   ****"
    info_msg "**************************************"
}

function setup_gui {
    info_msg "Setting up GUI packages"
    ker_ver=kernel-devel-
    ker_ver+=$(uname -r)
    echo $ker_ver
    sudo yum install -y $ker_ver # Needed to re-build ENA driver
    sudo yum groupinstall -y "Server with GUI"
    sudo systemctl set-default graphical.target

    sudo yum -y install epel-release
    sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
    sudo yum install -y xrdp tigervnc-server
    sudo yum install -y chromium
    sudo systemctl start xrdp
    sudo systemctl enable xrdp
    sudo systemctl disable firewalld
    sudo systemctl stop firewalld
}

function info_msg {
  echo -e "INFO: $1"
}

function err_msg {
  echo -e >&2 "ERROR: $1"
}

setup_gui
setup_password

popd
