#!/bin/bash
BORG=borg
SERVER=borgserver
REPOS=/var/backup/$(hostname)
PATH_TO_BACKUP=/etc
COMPRESSION=lz4
TIMESTAMP="$(date +"%Y-%m-%d-%H:%M:%S")-$(hostname)"
export BORG_RSH="ssh -i ~/.ssh/id_rsa"
export BORG_REPOS=borg@$SERVER:$REPOS
export BORG_PASSPHRASE='vagrant'

$BORG lsit