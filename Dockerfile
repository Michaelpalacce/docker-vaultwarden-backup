FROM alpine:latest

ENV CRON_SCHEDULE="0 */6 * * *"
ENV RETENTION_TIME_DAYS="30"
ENV BACKUP_ENCRYPTION_KEY="SomeDecryptionKey"

# install sqlite, curl, bash (for script)
RUN apk add --no-cache \
    sqlite \
    curl \
    bash \
    openssl

# copy backup script to crond daily folder
COPY backup.sh /

# copy entrypoint to usr bin
COPY entrypoint.sh /

# give execution permission to scripts
RUN chmod +x /entrypoint.sh && \
    chmod +x /backup.sh

ENTRYPOINT ["/entrypoint.sh"]