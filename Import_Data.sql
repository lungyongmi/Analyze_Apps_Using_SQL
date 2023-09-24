-- Create Database
CREATE DATABASE IF NOT EXISTS applestore;

USE applestore;

-- Create Table applestore and Import Data applestore.csv
DROP TABLE IF EXISTS applestore;
CREATE TABLE applestore(
  id INT NOT NULL PRIMARY KEY, 
  track_name VARCHAR(255),
  size_bytes BIGINT,
  currency VARCHAR(255),
  price DECIMAL,
  rating_count_tot INT,
  rating_count_ver INT,
  user_rating DECIMAL,
  user_rating_ver DECIMAL,
  ver VARCHAR(255),
  cont_rating VARCHAR(255),
  prime_genre VARCHAR(255),
  sup_devices_num INT,
  ipadSc_urls_num INT,
  lang_num INT,
  vpp_lic INT);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/applestore.csv'
INTO TABLE applestore
CHARACTER SET latin7
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- Create Table app_description and Import Data app_description.csv
DROP TABLE IF EXISTS app_description;
CREATE TABLE app_description(
  id INT NOT NULL,
  track_name VARCHAR(1000),
  size_bytes BIGINT,
  app_desc TEXT(50000));
