# mysql-dropbox-backup

Dump MySQL databases and compress them before uploading them to [Dropbox] for a simple off-site backup. Backups are kept for 7 days. \
Forked from [mysql-dropbox-backup] and improved to suit my needs.

Mainly, removing the openssl encryption I don't need and switching the db_ignore to a db_include kind of script.

## Overview

`mysql-dropbox-backup` is a simple shell script that will use `mysqldump` to export the databases you select to a compressed tarball. Then proceeds to upload them to [Dropbox] for a simple off-site backup solution. The script makes use of the [Dropbox-Uploader] project by [Andrea Fabrizi]. Run it as a daily cron job to keep 7 days of backups. On each run it will try to delete the backup taken 7 days ago.

## Requirements

* cURL
* A [Dropbox] account
* [Dropbox-Uploader]

Most Linux systems will come with cURL installed. [Dropbox] gives away 2GB of storage for free.

## Installation

First grab a copy of [Dropbox-Uploader], follow its installation instructions, and link it to your [Dropbox] account. \
I have it installed in my home directory, but pick any location the works for you.

Next get a copy of `mysql-dropbox-backup.sh` and `mysql-dropbox-backup.cnf`, and save them in the same directory as `dropbox_uploader.sh`.

Edit `mysql-dropbox-backup.cnf` to add your MySQL connection details.

Edit the top section of `mysql-dropbox-backup.sh` to configure the database names that you want to back up. If your `mysql-dropbox-backup.cnf` files is someplace else change the path to that too.

## Usage

`mysql-dropbox-backup` is run from the CLI, taking no parameters.

```
./mysql-dropbox-backup.sh
```

Ideally it be run as a daily cron job. After uploading the present backup, it will attempt to delete the backup from 7 days previous, so that only one week of backups are kept.

The script is quite verbose and will output which databases were backed up and the names of any files generated etc...

## Restoring a Backup

In the unfortunate event that you need to use a backup, it can be decrypted and the tarball expanded as follows, once downloaded from [Dropbox]:

```
tar xz
```

Then the SQL files will be available to restore within the resulting directory.

   [Dropbox]: <https://www.dropbox.com>
   [mysql-dropbox-backup]: <https://github.com/andreafabrizi/Dropbox-Uploader>
   [Dropbox-Uploader]: <https://github.com/andreafabrizi/Dropbox-Uploader>
   [Andrea Fabrizi]: <https://github.com/andreafabrizi>
