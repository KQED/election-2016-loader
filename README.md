# Election 2016 Loader

##About
A loader that collects election results from AP API and loads them into MySQL. Inspiration for some of this repo was taken from [NPR's Elex Loader](https://github.com/nprapps/ap-election-loader).

##Requirements
- MySQL
- jq

##Configuration
Set the following environment variables:
```
$ export AP_API_KEY='YOUR_AP_API_KEY'
$ export ELECTIONS_DB_HOST='YOUR_MYSQL_HOST'
$ export ELECTIONS_DB_USER='YOUR_MYSQL_USERNAME'
$ export ELECTIONS_DB_PASS='YOUR_MYSQL_PASSWORD'
$ export ELECTIONS_DB_PORT='YOUR_MYSQL_PORT'
$ export MYSQL_COMMAND='mysql'
```

##Installation
```
$ git clone https://github.com/KQED/election-2016-loader.git
$ cd election-2016-loader
```

##Running the Service Locally
```
$ mysql.server start
$ source init.sh
$ source results.sh
```

##Ebextensions
The ebextensions folder has two config files which run when deployed to an AWS Elastic Beanstalk instance
- createdb.config creates the database election2016 if it doesn't exist and drops and creates the APresults table, if it exists. It then indexes the AP data into the APresults table
- mysqlinstall.config installs mysql and and jq in the Linux server
