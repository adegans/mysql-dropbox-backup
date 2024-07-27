#!/bin/bash

################################################################
# Configuration section                                        #
#                                                              #
# Enter your MySQL connection details in the config file shown #
# below, choose which databases should be backed up            #
################################################################

# List of databases to back-up (space separated)
db_include=(database1 database2 database3)

# MySQL config file (Can probably stay as-is)
config=./mysql-dropbox-backup.cnf

################################
# End of configuration section #
#                              #
# Nothing to edit below here   #
################################

# Get a list of databases
db_arr=$(echo "show databases;" | mysql --defaults-extra-file=$config)

# Get the current date. Used for file names etc...
current_date=$(date +"%Y-%m-%d")

# Get the date 7 days ago. Used to delete the redundant backup file.
old_date=$(date +"%Y-%m-%d" --date="7 days ago")

# Create a temporary backup directory to hold the SQL files, which will be deleted later
mkdir $current_date

# Backup each database (omitting any in the ignore list)
for dbname in ${db_arr}
do
    for i in "${db_include[@]}"
    do
        if [[ ${db_include[*]} =~ "$dbname" ]] ; then
            sqlfile=$current_date"/"$dbname".sql"
            echo "Dumping $dbname to $sqlfile"
            mysqldump --defaults-extra-file=$config $dbname > $sqlfile
            break
        fi
    done
done

# Tar and compress the dumped SQL files
echo "Compressing dumped SQL files..."
tar -czf $current_date.tgz ./$current_date

# Remove the backups directory
echo "Removing dumped SQL files..."
rm -rf $current_date/

# Upload the backup tarball to Dropbox
echo "Uploading backup tarball to Dropbox..."
./dropbox_uploader.sh upload $current_date.tgz $current_date.tgz

# Delete the old backup
echo "Deleting old Dropbox backup..."
./dropbox_uploader.sh delete $old_date.tgz

# Delete the local copy of the backup tarball that we just created
echo "Deleting local backup tarball..."
rm -f $current_date.tgz

echo "Finished"
