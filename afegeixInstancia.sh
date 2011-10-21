#!/bin/bash

GENWEB_FOLDER=/var/plone/genwebupcZEO/produccio

INSTANCIES=/var/plone/genwebupcZEO/produccio/instances

echo "Un cop acabi el procediment, recorda de realitzar la mateixa operacio als frontends: SYLARA, SYLARB i SYLARC!!!"
echo "Regenerant Buildout..."
cd $GENWEB_FOLDER
$GENWEB_FOLDER/bin/buildout -o

chown -R plone $GENWEB_FOLDER

echo "Reiniciant zeo11..."
$GENWEB_FOLDER/bin/zeo11 stop
sleep 2
$GENWEB_FOLDER/bin/zeo11 start
