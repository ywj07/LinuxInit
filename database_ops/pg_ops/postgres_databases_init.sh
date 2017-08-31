#!/bin/bash

# by yeweijie
# 20170731
# 用于对本地postgresql进行表创建；CDH初始化使用

psql -h127.0.0.1 -p5432  -Upostgres -t << EOF
CREATE USER amon WITH PASSWORD 'amon';
CREATE DATABASE amon;
GRANT ALL PRIVILEGES ON DATABASE amon to amon;

CREATE USER hive WITH PASSWORD 'hive';
CREATE DATABASE hive;
GRANT ALL PRIVILEGES ON DATABASE hive to hive;


CREATE USER oozie_oozie_server WITH PASSWORD 'oozie_oozie_server';
CREATE DATABASE oozie_oozie_server;
GRANT ALL PRIVILEGES ON DATABASE oozie_oozie_server to oozie_oozie_server;


CREATE USER sqoop WITH PASSWORD 'sqoop';
CREATE DATABASE sqoop;
GRANT ALL PRIVILEGES ON DATABASE sqoop to sqoop;


EOF
