/* Proiectul de bash 
1. Script de instalare automata MySQL, creare de user in MySQL si import de DB dintr-un SQL dump file la alegere.
2. Script de backup pentru DB-ul de mai sus care face upload la sql dump file intr-un AWS S3 bucket (puteti sa va 
   faceti cont de AWS gratuit. pana la 5gb e gratis storage in S3).
3. Faceti un cron job care ruleaza script-ul de back-up odata pe ora. la fiecare rulare sa scrie intr-un fisier 
   CSV o linie cu urmatoarele infomatii: "Data,Ora,DumpSize".
Timotei Perju - timotei.perju@verticaldigital.ca on 02-06-2022 */

DROP DATABASE IF EXISTS verticaldb;

CREATE DATABASE IF NOT EXISTS verticaldb;

USE verticaldb;

SELECT 'CREATING DATABASE STRUCTURE' AS 'INFO';

DROP TABLE IF EXISTS dept_emp, dept_manager, titles, salaries, employees,
departments;

CREATE TABLE employees
  (
     emp_no     INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR(14) NOT NULL,
     last_name  VARCHAR(16) NOT NULL,
     gender     ENUM ('M', 'F') NOT NULL,
     hire_date  DATE NOT NULL,
     PRIMARY KEY (emp_no)
  );

CREATE TABLE departments
  (
     dept_no   CHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE KEY (dept_name)
  ); 