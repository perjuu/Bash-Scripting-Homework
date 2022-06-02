#!/bin/bash
#### Proiectul de bash
#### 1. Script de instalare automata MySQL, creare de user in MySQL si import de DB dintr-un SQL dump file la alegere.
#### 2. Script de backup pentru DB-ul de mai sus care face upload la sql dump file intr-un AWS S3 bucket (puteti sa va 
####    faceti cont de AWS gratuit. pana la 5gb e gratis storage in S3).
#### 3. Faceti un cron job care ruleaza script-ul de back-up odata pe ora. la fiecare rulare sa scrie intr-un fisier 
####    CSV o linie cu urmatoarele infomatii: "Data,Ora,DumpSize".
#### Timotei Perju - timotei.perju@verticaldigital.ca on 02-06-2022

DB="verticalDB"
echo "######## Checking for updates ########"
sudo apt-get update
echo "######## Install MySQL Server ########"
sudo apt-get install mysql-server -y
MYSQLSERVICE=`systemctl is-active mysql`
echo "Mysql service is: $MYSQLSERVICE"
echo "#######################################"

if [ $(echo "SELECT COUNT(*) FROM mysql.user WHERE user = 'admin'" | mysql | tail -n1) -gt 0 ]
then
    echo "User exists"
else
    echo "Creating new user"
    mysql -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY '1234';"
fi

mysql -e "SELECT User, Host FROM mysql.user;"
mysql < createDB.sql
echo "#######################################"
mysql -e "show databases;use $DB; show tables;"
echo "########### Install AWS CLI ###########"
sudo apt-get install awscli -y
cat <(crontab -l) <(echo "0 * * * * /etc/scripts/backup.sh") | crontab -
crontab -l