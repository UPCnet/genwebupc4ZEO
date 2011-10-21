#!/bin/bash

# per a fer un full : ./cron_nocturn.sh full

GWROOT_FOLDER=/var/plone/genwebupcZEO

GENWEB_FOLDER=/var/plone/genwebupcZEO/produccio

ENTORNS=/var/plone/genwebupcZEO/entorns

INSTANCIES=/var/plone/genwebupcZEO/produccio/instancies

INSTANCIES_PORT=/var/plone/genwebupcZEO/produccio/config/sylar-ports-db.conf

BACKUP_FOLDER=/backup/genwebupc

LOGBACKUP=/var/plone/genwebupcZEO/backup.log

BACKUPDIR=`date +%d`

## Funcions
function packEntorn {
    exec<$INSTANCIES/$1
    while read line
    do
        instancia=`echo ${line%% *}`
        echo "Packing $instancia at $1"
        $GENWEB_FOLDER/bin/zeopack -S $instancia -p $2 -h 127.0.0.1
    done
}

function inicialitzaBackupEntorn {
    echo "Comprovant si existeixen els folders necessaris"
    # Comprovem que existeix el folder corresponent al backup dels blobs
    if ! [ -x $BACKUP_FOLDER/$1 ] ; then
        mkdir $BACKUP_FOLDER/$1
    fi
    # Comprovem que existeix el folder current-blobs
    if ! [ -x $BACKUP_FOLDER/$1/current-blobs ]; then
        mkdir $BACKUP_FOLDER/$1/current-blobs
    fi
    # Comprovem que existeix el folder blobs
    if ! [ -x $BACKUP_FOLDER/$1/blobs ]; then
        mkdir $BACKUP_FOLDER/$1/blobs
    fi
    # Comprovem que existeix el folder corresponent al backup dels blobs
    if ! [ -x $BACKUP_FOLDER/$1/blobs/$BACKUPDIR ] ; then
        mkdir $BACKUP_FOLDER/$1/blobs/$BACKUPDIR
    fi
}

function backupZODBsEntorn {
    while read line
    do
        instancia=`echo ${line%% *}`

        echo "Comprovant si existeixen els folders necessaris"
        # Comprovem que existeix el folder de backup de la ZODB
        if ! [ -x $BACKUP_FOLDER/$1/$instancia ]; then
            mkdir $BACKUP_FOLDER/$1/$instancia
        fi

        # backup de Data.fs
        echo "Backup ZODB de la instancia $instancia"
        if  [ "$1" = "full" ]; then
             $GENWEB_FOLDER/bin/repozo -B -F -r $BACKUP_FOLDER/$1/$instancia/ -f $GENWEB_FOLDER/var/filestorage/Data_$instancia.fs
             echo "Purgant backups antics de la instancia $instancia"
             #$GWROOT_FOLDER/neteja.py -l $BACKUP_FOLDER/$1/$instancia -k 2
        else
             $GENWEB_FOLDER/bin/repozo -B -r $BACKUP_FOLDER/$1/$instancia/ -f $GENWEB_FOLDER/var/filestorage/Data_$instancia.fs
        fi

        # backup blobs
        echo "Backup dels blobs de la instancia $instancia"
        echo "rsync --force --ignore-errors --delete --update -a $GENWEB_FOLDER/var/blobs/$instancia/ $BACKUP_FOLDER/$1/current-blobs/$instancia/"
        rsync --force --ignore-errors --delete --update -a $GENWEB_FOLDER/var/blobs/$instancia/ $BACKUP_FOLDER/$1/current-blobs/$instancia/
    done <$INSTANCIES/$1
}

function actualitzaBackupBlobsAvui {
    if [ -x $BACKUP_FOLDER/$1/blobs/$BACKUPDIR/ ] ; then
        rm -rf $BACKUP_FOLDER/$1/blobs/$BACKUPDIR
    fi
    cd $BACKUP_FOLDER/$1/current-blobs && find . -print | cpio -dplm $BACKUP_FOLDER/$1/blobs/$BACKUPDIR
}

echo "INICI BACKUP" >> $LOGBACKUP
echo `date` >> $LOGBACKUP

### Executat per n entorns

while read line
do
    echo "$line"
    port=`echo ${line#* }`
    entorn=`echo ${line%% *}`
    # Fem pack de totes els instancies de l'entorn
    if [ "$1" = "full" ]; then
        packEntorn $entorn $port
    fi
    
    # Fem backup de totes les ZODBs i dels blobs corresponents a totes les instancies de l'entorn
    inicialitzaBackupEntorn $entorn
    backupZODBsEntorn $entorn $port
    actualitzaBackupBlobsAvui $entorn
done <$ENTORNS

echo "FI BACKUP" >> $LOGBACKUP
echo `date` >> $LOGBACKUP
