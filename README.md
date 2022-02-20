# bitwarden_rs-local-backup
Create encrypted backups of your Bitwarden_RS database locally every 6 hours. Maintains backups from the last 30 days.

**Important:** Make sure to securely store your backup encryption key somewhere outside your vault (e.g. printed and stored in physical safe). Losing your backup encryption key will make all backups useless.

## Required ENV variable
```
BACKUP_ENCRYPTION_KEY=SomeDecryptionKey
RETENTION_TIME_DAYS=30
CRON_SCHEDULE=0 */6 * * *
```

## Decrypting Backups
1. `docker exec -it CONTAINER_ID /bin/bash`
2. `openssl enc -d -aes256 -salt -pbkdf2 -pass pass:BACKUP_ENCRYPTION_KEY -in /backups/DESIRED_BACKUP_NAME.tar.gz | tar xz -C /backups`
3. Grab your `db.sqlite3` file from `/host/path/to/backups/tmp/`