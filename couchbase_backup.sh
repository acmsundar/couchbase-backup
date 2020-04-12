#!/bin/bash

DIRECTORY_NAME=`dirname $0`
COUCHBASE_CONF="couchbase.conf"
BACKUP_ID=`date '+%Y%m%d%H%M%S'`

if [[ $(id -u) != 0 ]]
then

  echo "Script needs to be executed by root !"
  echo "Usage: $0 BUCKET"
  exit 1

fi

source ${DIRECTORY_NAME}/${COUCHBASE_CONF}

# Checking # of arguments

if [[ "$#" -ne 1 ]]
then
  echo "Usage: $0 BUCKET"
  echo "Provide the bucket name, which needs to backed up !"
  exit 1
fi

BUCKET=$1

${COUCHBASE_DIR}/bin/cbbackup ${COUCHBASE_SERVER_IP}:${COUCHBASE_SERVER_PORT} ${COUCHBASE_BACKUP_BKPS_DIR}/${BACKUP_ID} -m full -b ${BUCKET} -u ${COUCHBASE_ADMIN} -p ${COUCHBASE_PASSWORD}
exit_code=$?

if [[ $exit_code -ne 0 ]]
then
  echo "Unknown error, while processing backup command"
  echo "Please make sure the bucket name and other configurations are set correctly !"
  exit 1
fi

tar -czf ${COUCHBASE_BACKUP_BKPS_DIR}/${BACKUP_ID}.tar.gz -C ${COUCHBASE_BACKUP_BKPS_DIR} ${BACKUP_ID}/


rm -rf ${COUCHBASE_BACKUP_BKPS_DIR}/${BACKUP_ID}

echo "Backup for ${BUCKET} is completed successfully !"

exit 0
