#!/bin/sh

# run backup once on container start to ensure it works
/backup.sh

RUN echo "${CRON_SCHEDULE} /backup.sh" > /etc/crontabs/root

# start crond in foreground
exec crond -f