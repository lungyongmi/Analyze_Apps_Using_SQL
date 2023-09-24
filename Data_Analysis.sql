-- Explore Data
SELECT *
FROM applestore;

SELECT *
FROM app_description;

-- Check the number of unique app between tables
SELECT COUNT(DISTINCT id) AS UniqueApp
FROM applestore;

SELECT COUNT(DISTINCT id) AS UniqueApp
FROM app_description;

-- Check missing values in key columns
SELECT COUNT(*) AS MissingValue
FROM applestore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL;

SELECT COUNT(*) AS MissingValue
FROM app_description
WHERE app_desc IS NULL;

-- Number of apps by genre
SELECT prime_genre AS Genre, COUNT(*) AS num
FROM applestore
GROUP BY Genre
ORDER BY num DESC;

-- Average of app ratings and paid app price
SELECT ROUND(AVG(user_rating), 1) AS AvgRating,
       ROUND((SELECT AVG(price) FROM applestore WHERE price > 0), 1) AS AvgPrice
FROM applestore;

-- Data Anaysis
-- Check whether paid apps have higher ratings than free apps
SELECT CASE
		 WHEN price > 0 THEN 'Paid'
         ELSE 'Free'
	   END AS AppType,
       ROUND(AVG(user_rating), 1) AS Rating
FROM applestore
GROUP BY AppType;

-- Check if apps with more supporting languages have higher rating
SELECT CASE
		 WHEN lang_num < 10 THEN '<10 languages'
		 WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
		 ELSE '>30 languages'
	   END AS LangType,
       ROUND(AVG(user_rating), 1) AS AvgRating
FROM applestore
GROUP BY LangType
ORDER BY AvgRating DESC;

-- Check genre with low ratings
SELECT prime_genre AS Genre,
	   ROUND(AVG(user_rating), 1) AS AvgRating
FROM applestore
GROUP BY Genre
ORDER BY AvgRating
LIMIT 5;

-- Check correlation between app description and rating
SELECT CASE
		 WHEN LENGTH(ad.app_desc) < 500 THEN 'short'
         WHEN LENGTH(ad.app_desc) BETWEEN 500 AND 1000 THEN 'medium'
         ELSE '1ong'
	   END AS DescLen,
       ROUND(AVG(a.user_rating), 1) AS AvgRating
FROM applestore a
JOIN app_description ad ON a.id = ad.id
GROUP BY DescLen;

-- Check correlation between app screenshot and rating
SELECT CASE
		 WHEN ipadSc_urls_num < 1 THEN 'No Screenshot'
         WHEN ipadSc_urls_num BETWEEN 1 AND 3 THEN '1-3 Screenshot'
         ELSE '4-5 Screenshot'
	   END AS ScrnType,
       ROUND(AVG(user_rating), 1) AS AvgRating
FROM applestore 
GROUP BY ScrnType
ORDER BY AvgRating DESC;

-- Top rating app in each genre
WITH top_app AS(
SELECT prime_genre,
	   track_name,
       user_rating,
       rating_count_tot,
	   RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS tot_r
FROM applestore)

SELECT prime_genre AS Genre,
	   track_name AS App,
       user_rating AS Rating
FROM top_app
WHERE tot_r = 1
ORDER BY rating_count_tot DESC;
