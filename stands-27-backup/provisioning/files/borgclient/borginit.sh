#!/bin/bash
export BORG_REPO=borg@borgserver:/var/backup/$(hostname)
borg init --encryption=keyfile --append-only $BORG_REPOS
borg key export $BORG_REPOS ~/borg-server-backup.key