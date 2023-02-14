#!/bin/bash

source BP-BASE-SHELL-STEPS/functions.sh
source BP-BASE-SHELL-STEPS/log-functions.sh
source BP-BASE-SHELL-STEPS/str-functions.sh
source BP-BASE-SHELL-STEPS/file-functions.sh
source BP-BASE-SHELL-STEPS/aws-functions.sh

logInfoMessage "I'll take a backup of the buildpiper mysql database"
logInfoMessage "Received below arguments"
logInfoMessage "Database: $DATABASE"
logInfoMessage "Database backup directory: $DATABASE_BACKUP_DIR"

CURRENT_DATE=$(date "+%D-%T")

if [ -f "key.pem" ]; then
   true
else
   cat "$PRIVATE_KEY" > key.pem && chmod 400 key.pem
fi

SERVER="ssh $USERNAME@$IP_ADDRESS -i key.pem -p $SSH_PORT -o stricthostkeychecking=no"

if [ ! -d "$DATABASE_BACKUP_DIR" ]; then
   echo "Creating directory for mysql database backup: $DATABASE_BACKUP_DIR"
   mkdir $DATABASE_BACKUP_DIR 
else
   true
fi

DB_CONTAINER=$( $SERVER "docker ps" | awk '{print $NF}' | grep 'db')

if [ "$DB_CONTAINER" == "db" ]; then
   $SERVER docker exec -i db mysqldump -u$DB_USER -p$DB_PASSWORD $DATABASE > $DATABASE_BACKUP_DIR/sql_dump_$CURRENT_DATE.sql
   logInfoMessage "Congratulations Buildpiper database backup has been successfully taken!!!"
   generateOutput $ACTIVITY_SUB_TASK_CODE true "Congratulations Buildpiper database backup has been successfully taken!!!"
else
  if [ $VALIDATION_FAILURE_ACTION == "FAILURE" ]
  then
      logErrorMessage "db: Container not found"
      logErrorMessage "Failed to take buildpiper database backup please check!!!"
      generateOutput $ACTIVITY_SUB_TASK_CODE false "Failed to take buildpiper database backup please check!!!"
      exit 1
  else
      logWarningMessage "db: Container not found"
      logWarningMessage "Failed to take buildpiper database backup please check!!!"
      generateOutput $ACTIVITY_SUB_TASK_CODE true "Failed to take buildpiper database backup please check!!!"
  fi
fi
