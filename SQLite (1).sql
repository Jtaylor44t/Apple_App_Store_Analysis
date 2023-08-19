/* Due to the limitations of the tool I'm using (sqliteonline.com), I need to split the main appleStore_description file into 4 files. */

/* Creating a table of the combined 4 appleStore_description csv files */
CREATE TABLE appleStore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

/* Doing some exploratory data analysis */

-- Checking the number of unique apps in both tables

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description_combined
-- Both results match, so there is no missing data in either table in the id column 

-- Checking for any missing values in some key fields 
SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL

SELECT COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc IS NULL
-- Both results are 0. 

-- Finding out the number of apps per genre 

BAR-SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

-- Getting an overview of the apps' ratings 
-- I'm going to do this by getting the minimum rating, maximum rating, and the avg rating 

SELECT min(user_rating) AS MinRating,
	   max(user_rating) AS MaxRating,
       avg(user_rating) AS AvgRating
FROM AppleStore

-- Determining whether paid apps have higher ratings than free apps 

SELECT CASE
			WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
        END AS App_Type,
        avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY App_Type
-- Paid apps have a higher average rating than free apps 

-- Checking if apps with more supported languages have higher ratings 

SELECT CASE
			WHEN lang_num < 10 THEN '<10 Languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            ELSE '>30 languages'
        END AS language_bucket,
        avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY Avg_Rating DESC

-- Check genres with low ratings 

SELECT prime_genre,
	   avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
LIMIT 10
-- It looks like apps in the "Catalogs" genre have the lowest ratings. 

-- Checking for correlation between length of app description and the user rating 
-- I need to join the AppleStore table with the appleStore_description_combined table on the id(which is the key present in both tables) 

SELECT CASE
			WHEN length(b.app_desc) <500 THEN 'Short'
            WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
            ELSE 'Long'
        END AS description_length_bucket,
        avg(a.user_rating) AS average_rating     

FROM
	AppleStore AS A 
JOIN
	appleStore_description_combined AS b 
ON 
	a.id = b.id 
    
GROUP BY description_length_bucket
ORDER BY average_rating DESC
-- It seems that the longer the description, the higher the user rating. 

-- Checking the top-rated apps for each genre using a window function in a sub-query 

SELECT 
	prime_genre,
    track_name,
    user_rating
FROM (
	  SELECT
      prime_genre,
      track_name,
      user_rating,
/* Assigns a rank to each row and creates a separate window for each rank. 
 Rows are ranked by user rating and the top one in each genre is selected */
      RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
      FROM
      AppleStore
    ) AS a 
WHERE
a.rank = 1
  
-- Checking the most expensive app in each genre and it's user rating. 
SELECT 
	  prime_genre,
      price,
      user_rating
FROM (
	  SELECT
      prime_genre,
      price,
      user_rating,
/* Assigns a rank to each row and creates a separate window for each rank. 
 Rows are ranked by user rating and the top one in each genre is selected */
      RANK() OVER(PARTITION BY prime_genre ORDER BY price DESC, rating_count_tot DESC) AS rank
      FROM
      AppleStore
    ) AS a 
WHERE
a.rank = 1
-- It looks like the most expensive Education app is $299.99 

-- First I want to check the minimum and maxmium supported devices, and the average number of supported devices per app in this data set 
SELECT
	MIN(sup_devices_num) AS min_dev_supported,
    MAX(sup_devices_num) AS max_dev_supported,
    avg(sup_devices_num) AS avg_dev_supported
FROM
	AppleStore
-- the app with the lowest number of supported devices only supports 9 devices. 
-- the max is 47 devices and the average is 37 devices. 

-- Checking if more supported devices means a higher rating 
LINE-SELECT CASE
			WHEN sup_devices_num < 15 THEN '<15 devices supported'
            WHEN lang_num BETWEEN 10 AND 30 THEN '15-30 devices supported'
            ELSE '>Over 30 devices supported'
        END AS supported_devices_bucket,
        avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY supported_devices_bucket
ORDER BY Avg_Rating DESC
-- It appears that apps that support more devices don't typically have higher ratings. This factor can most likely be ignored when developing the app. 

























