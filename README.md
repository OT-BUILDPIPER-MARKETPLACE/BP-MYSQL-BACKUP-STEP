# BP-MYSQL-BACKUP-STEP

This step will help you to take backup of the buildpiper database.

## Setup
* Clone the code available at [BP-MYSQL-BACKUP-STEP](https://github.com/OT-BUILDPIPER-MARKETPLACE/BP-MYSQL-BACKUP-STEP.git)
* Build the docker image
```
git submodule init
git submodule update
docker build -t ot/db-backup:0.1 .
