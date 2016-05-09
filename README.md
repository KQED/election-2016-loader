# Election 2016 Loader

##About
A loader that collects election results from AP API and CA Secretary of State XML feed and loads them into MySQL. Inspiration for some of this repo was taken from [NPR's Elex Loader](https://github.com/nprapps/ap-election-loader).

##Requirements
- MySQL

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
Note: This loader is programmed to use a database named 'election2016'.

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
