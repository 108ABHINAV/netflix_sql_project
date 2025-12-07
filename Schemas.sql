create database netflix; # create database

use netflix; # using database

drop table if exists netflix; # drop table if already exists
create table netflix # create table 
(
	show_id varchar(5),
    type_name varchar(10),
    title varchar(150),
    director varchar(220),
    casts varchar(1000),
    country varchar(150),
    date_added varchar(50),
    release_year int,
    rating varchar(15),
    duration varchar(15),
    listed_in varchar(100),
    description varchar(250)
    
);

# import data from csv
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/netflix_titles.csv'
INTO TABLE netflix
CHARACTER SET utf8
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;