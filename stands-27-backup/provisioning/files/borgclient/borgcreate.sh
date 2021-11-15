#!/bin/bash
BORG=borg
SERVER=borgserver
REPOS=/var/backup/$(hostname)
PATH_TO_BACKUP=/etc
COMPRESSION=lz4
LOG="/var/log/backup/backup-$(date +"%Y-%m-%d-%H:%M:%S").log"

TIMESTAMP="$(date +"%Y-%m-%d-%H:%M:%S")-$(hostname)"
export BORG_RSH="ssh -i ~/.ssh/id_rsa"
export BORG_REPOS=borg@$SERVER:$REPOS
export BORG_PASSPHRASE='vagrant'
exec > >(tee -i ${LOG})
exec 2>&1

echo "###### Backup started: $(date) ######"
# use lz4 compression and log into file
$BORG create -v --filter AME --list --stats --show-rc --compression $COMPRESSION $BORG_REPOS::$TIMESTAMP $PATH_TO_BACKUP 
$BORG prune -v --list --keep-yearly=1 --keep-monthly=12 --keep-weekly=7 --keep-daily=1 ${BORG_REPOS}
echo "###### Backup ended: $(date) ######"
