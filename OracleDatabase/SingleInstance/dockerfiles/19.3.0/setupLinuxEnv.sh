#!/bin/bash
# LICENSE UPL 1.0
#
# Copyright (c) 1982-2018 Oracle and/or its affiliates. All rights reserved.
#
# Since: December, 2016
# Author: gerald.venzl@oracle.com
# Description: Sets up the unix environment for DB installation.
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# 

# Setup filesystem and oracle user
# Adjust file permissions, go to /opt/oracle as user 'oracle' to proceed with Oracle installation
# ------------------------------------------------------------
mkdir -p $ORACLE_BASE/scripts/setup && \
mkdir $ORACLE_BASE/scripts/startup && \
ln -s $ORACLE_BASE/scripts /docker-entrypoint-initdb.d && \
mkdir $ORACLE_BASE/oradata && \
mkdir -p $ORACLE_HOME && \
chmod ug+x $ORACLE_BASE/*.sh && \
#yum -y install oracle-database-preinstall-19c openssl && \
yum -y localinstall /opt/install/oracle-database-preinstall-19c-1.0-1.el7.x86_64.rpm   \
&& yum -y install openssl  \
&& yum -y install openssl-devel \
&& yum -y install lsof \
&& yum -y install iproute \
&& yum -y install net-tools \
&& yum -y install rsyslog \
&& yum -y install bash-completion \
&& yum -y install tmux \
&& yum -y install lrzsz \
&& yum -y install telnet \
&& yum -y localinstall /opt/install/rlwrap-0.42-1.el6.x86_64.rpm && \
rm -rf /var/cache/yum && \
ln -s $ORACLE_BASE/$PWD_FILE /home/oracle/ && \
echo oracle:oracle | chpasswd && \
echo root:oracle | chpasswd && \
chown -R oracle:dba $ORACLE_BASE
