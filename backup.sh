#!/bin/sh

echo "Starting"
# rm any backups older than 30 days
find /backups/* -mtime +"${RETENTION_TIME_DAYS}" -exec rm {} \;
echo "Finished cleaning up old backups"

# create backup filename
BACKUP_FILE="backup_$(date "+%F-%H%M%S")"
LATEST_BACKUP_FILE="/backups/latest.tar.gz"
WORKDIR="/tmp/currBackup"

# Recreate workdir
rm -rf ${WORKDIR}
mkdir -p ${WORKDIR}

echo "Recreated Workdir"

# Remove latest backup
rm -rf ${LATEST_BACKUP_FILE}

# use sqlite3 to create backup (avoids corruption if db write in progress)
cp -r /data/* ${WORKDIR}
# Remove all sqlite3 data ( db, shm, wal )
rm -rf ${WORKDIR}/db.sqlite*
sqlite3 /data/db.sqlite3 ".backup '${WORKDIR}/db.sqlite3'"

echo "Created new Backup"

# tar up backup and encrypt with openssl and encryption key
tar -czf - ${WORKDIR} | openssl enc -e -aes256 -salt -pbkdf2 -pass pass:"${BACKUP_ENCRYPTION_KEY}" -out /backups/"${BACKUP_FILE}".tar.gz
echo "Created encrypted zip"
# Add a "latest" backup
cp /backups/"${BACKUP_FILE}".tar.gz ${LATEST_BACKUP_FILE}
echo "Created a latest zip"

# cleanup tmp folder
rm -rf /tmp/*
echo "DONE"