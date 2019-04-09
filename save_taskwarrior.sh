#!/usr/bin/env bash

TASK_BACKUP_DIR=/home/adfaure/Data/taskwarrior-backup
TASK_DIR=`task diagnostics|grep Data:| sed -e "s/ \+/ /g"|cut -d " " -f 3`

cd $TASK_BACKUP_DIR && tar -czf task-backup-$(date +'%Y%m%d').tar.gz -C $TASK_DIR .

TIMEW_BACKUP_DIR=/home/adfaure/Data/taskwarrior-backup
TIMEW_DIR=`timew diagnostics|grep Database:| sed -e "s/ \+/ /g"|cut -d " " -f 3`

cd $TIMEW_BACKUP_DIR && tar -czf timew-backup-$(date +'%Y%m%d').tar.gz -C $TIMEW_DIR .
