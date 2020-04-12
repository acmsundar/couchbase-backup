#!/bin/bash
# File name : install.sh

DIRECTORY_NAME=`dirname $0`
COUCHBASE_CONF="couchbase.conf"

source ${DIRECTORY_NAME}/${COUCHBASE_CONF}

# Exit codes for failures
# 1 - User ID
# 2 - /opt/couchbase-backup already exists

function print()
{
  local msg_time=`date '+%Y-%m-%d %H:%M:%S'`
  local msg_code=$1
  local msg=$2
  local msg_type
  if [[ $msg_code != 0 ]]
  then 
    msg_type="ERROR"
  else
    msg_type="INFO"
  fi
  echo "$msg_type:$msg_time:$msg"
}

# Check whether the id executing the script is root.

print 0 "Checking the user id"

if [[ $(id -u) == 0 ]]
then

  # Checking the folder existence for couchbase-backup in /opt

  if [[ -d "${COUCHBASE_BACKUP_DIR}" ]];
  then

    print 1 "Directory with the name as ${COUCHBASE_BACKUP_DIR} exists, please clean up to proceed the installation !"
    exit 2

  else

    print 0 "${COUCHBASE_BACKUP_DIR} directory doesn't exist"

    print 0 "Directory creation"
    
    mkdir ${COUCHBASE_BACKUP_DIR}

    mkdir ${COUCHBASE_BACKUP_LOG_DIR}

    mkdir ${COUCHBASE_BACKUP_BKPS_DIR}

    cp ${DIRECTORY_NAME}/${COUCHBASE_CONF} ${COUCHBASE_BACKUP_DIR}/

    cp ${DIRECTORY_NAME}/couchbase_backup.sh ${COUCHBASE_BACKUP_DIR}/

    chmod 600 ${COUCHBASE_BACKUP_DIR}/${COUCHBASE_CONF}

    chmod 755 ${COUCHBASE_BACKUP_DIR}/couchbase_backup.sh

    print 0 "Initialization of scripts and directories are complete"

    exit 0

  fi


else

  print 1 "Please execute the script with root user !!!"
  exit 1

fi
