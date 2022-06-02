#!/bin/bash
#### Proiectul de bash
#### 1. Script de instalare automata MySQL, creare de user in MySQL si import de DB dintr-un SQL dump file la alegere.
#### 2. Script de backup pentru DB-ul de mai sus care face upload la sql dump file intr-un AWS S3 bucket (puteti sa va 
####    faceti cont de AWS gratuit. pana la 5gb e gratis storage in S3).
#### 3. Faceti un cron job care ruleaza script-ul de back-up odata pe ora. la fiecare rulare sa scrie intr-un fisier 
####    CSV o linie cu urmatoarele infomatii: "Data,Ora,DumpSize".
#### Timotei Perju - timotei.perju@verticaldigital.ca on 02-06-2022

echo "starting db backup"
date=$(date '+%Y-%m-%d')
hour=$(date '+%T')

if ! [ -d "backup" ]
then
    mkdir backup
fi

dbbackup="backup/mydb${date}${hour}.sql"
mysqldump -u root verticalDB > ${dbbackup}
dumpsize=$(stat -c%s "$dbbackup")

if ! [ -e history.csv ]
then
    printf '%s\n' DATA ORA DumpSize | paste -sd ' ' >> history.csv
fi
    printf '%s\n' $date $hour ${dumpsize} bytes | paste -sd ' ' >> history.csv

aws s3 cp "$dbbackup" s3://vertical05302022/backup/