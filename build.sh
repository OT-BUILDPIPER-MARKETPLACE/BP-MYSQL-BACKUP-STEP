#!/bin/bash

source functions.sh
source log-functions.sh
source str-functions.sh
source file-functions.sh
source aws-functions.sh

logInfoMessage "I'll take a backup of the buildpiper mysql database"
logInfoMessage "Received below arguments"
logInfoMessage "Database: $DATABASE"
logInfoMessage "Database backup directory: $DATABASE_BACKUP_DIR"

sleep $SLEEP_DURATION

CURRENT_DATE=$(date '+%e_%b_%Y-%I:%M' | sed 's/ //g')

if [ -f "key.pem" ]; then
   true
else
   echo -e "$SSH_PRIVATE_KEY_FILE" > key.pem
   sed -i 's/ \+/\'$'\n/g' key.pem && sed -i '1,4d' key.pem 
   sed -i '1 i -----BEGIN RSA PRIVATE KEY-----' key.pem && sed -i '27,30d' key.pem 
   echo "-----END RSA PRIVATE KEY-----" >> key.pem && chmod 400 key.pem
fi

SERVER="ssh $SSH_USERNAME@$SSH_IP_ADDRESS -i key.pem -p $SSH_PORT -o stricthostkeychecking=no"

if $SERVER [ -d $DATABASE_BACKUP_DIR ]; then
   true
else
   echo "Creating directory for mysql database backup: $DATABASE_BACKUP_DIR"
   $SERVER "mkdir $DATABASE_BACKUP_DIR" 
fi

DB_CONTAINER=$( $SERVER "docker ps" | awk '{print $NF}' | grep 'db')

if [ "$DB_CONTAINER" == "db" ]; then
   $SERVER "docker exec -i db mysqldump -u$CREDENTIAL_USERNAME -p$CREDENTIAL_PASSWORD $DATABASE > $DATABASE_BACKUP_DIR/sql_dump_$CURRENT_DATE.sql"
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
