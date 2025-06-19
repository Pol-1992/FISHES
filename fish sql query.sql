USE marine_biodiversity;

-- Top 10 most observed species

SELECT scientific_name, COUNT(*) AS total_observations
FROM (
SELECT scientific_name FROM thailand
UNION ALL
SELECT scientific_name FROM indonesia
UNION ALL
SELECT scientific_name FROM philippines
) AS all_species
GROUP BY scientific_name
ORDER BY total_observations DESC
LIMIT 10;

SELECT common_name, COUNT(*) AS total_observations
FROM (
SELECT common_name FROM thailand
UNION ALL
SELECT common_name FROM indonesia
UNION ALL
SELECT common_name FROM philippines
) AS all_species
GROUP BY common_name
ORDER BY total_observations DESC
LIMIT 10;

SELECT common_name, COUNT(*) AS total_observations
FROM thailand
GROUP BY common_name
ORDER BY total_observations DESC
LIMIT 10;

SELECT common_name, COUNT(*) AS total_observations
FROM indonesia
GROUP BY common_name
ORDER BY total_observations DESC
LIMIT 10;

SELECT common_name, COUNT(*) AS total_observations
FROM philippines
GROUP BY common_name
ORDER BY total_observations DESC
LIMIT 10;

-- Observations per year by country

SELECT country, YEAR(date) AS year, COUNT(*) AS total_observations
FROM (
SELECT 'thailand' AS country, date FROM thailand
UNION ALL
SELECT 'indonesia' AS country, date FROM indonesia
UNION ALL
SELECT 'philippines' AS country, date FROM philippines
) AS all_data
GROUP BY country, year
ORDER BY country, year;

-- Observations per month (all countries)

SELECT MONTH(date) AS month, COUNT(*) AS total_observations
FROM (
SELECT date FROM thailand
UNION ALL
SELECT date FROM indonesia
UNION ALL
SELECT date FROM philippines
) AS all_dates
GROUP BY month
ORDER BY month;

-- Observations per month by country

SELECT country, MONTH(date) AS month, COUNT(*) AS total_observations
FROM (
SELECT 'thailand' AS country, date FROM thailand
UNION ALL
SELECT 'indonesia', date FROM indonesia
UNION ALL
SELECT 'philippines', date FROM philippines
) AS dated_by_country
GROUP BY country, month
ORDER BY country, month;

-- Observations per month and year (all countries)

SELECT YEAR(date) AS year, MONTH(date) AS month, COUNT(*) AS total_observations
FROM (
SELECT date FROM thailand
UNION ALL
SELECT date FROM indonesia
UNION ALL
SELECT date FROM philippines
) AS dated
GROUP BY year, month
ORDER BY year, month;

-- Observations per year and common name (all countries)

SELECT common_name, YEAR(date) AS year, COUNT(*) AS total_observations
FROM (
SELECT common_name, date FROM thailand
UNION ALL
SELECT common_name, date FROM indonesia
UNION ALL
SELECT common_name, date FROM philippines
) AS species_year
GROUP BY common_name, year
ORDER BY common_name, year;

-- Observations of dolphins, whales and sharks (all countries)

SELECT common_name, country, YEAR(date) AS year, COUNT(*) AS total_observations
FROM (
SELECT common_name, country, date FROM thailand
UNION ALL
SELECT common_name, country, date FROM indonesia
UNION ALL
SELECT common_name, country, date FROM philippines
) AS all_obs
WHERE common_name LIKE '%shark%'
OR common_name LIKE '%whale%'
OR common_name LIKE '%dolphin%'
GROUP BY common_name, country, year
ORDER BY country, year, total_observations DESC;

-- Observations of sharks, whales and dolphins per month (all countries)

SELECT common_name, MONTH(date) AS month, COUNT(*) AS total_observations
FROM (
SELECT common_name, date FROM thailand
UNION ALL
SELECT common_name, date FROM indonesia
UNION ALL
SELECT common_name, date FROM philippines
) AS big_animals
WHERE common_name LIKE '%shark%'
OR common_name LIKE '%whale%'
OR common_name LIKE '%dolphin%'
GROUP BY common_name, month
ORDER BY common_name, month;

-- Observations of sharks, whales and dolphins by country and month

SELECT country, common_name, MONTH(date) AS month, COUNT(*) AS total_observations
FROM (
SELECT 'thailand' AS country, common_name, date FROM thailand
UNION ALL
SELECT 'indonesia' AS country, common_name, date FROM indonesia
UNION ALL
SELECT 'philippines' AS country, common_name, date FROM philippines
) AS marine_animals
WHERE common_name LIKE '%shark%'
OR common_name LIKE '%whale%'
OR common_name LIKE '%dolphin%'
GROUP BY country, common_name, month
ORDER BY country, common_name, month;

-- Observations per species per country

SELECT common_name, country, COUNT(*) AS total_observations
FROM (
SELECT common_name, country FROM thailand
UNION ALL
SELECT common_name, country FROM indonesia
UNION ALL
SELECT common_name, country FROM philippines
) AS all_obs
GROUP BY common_name, country
ORDER BY common_name, total_observations DESC;

-- Species seen in all 3 countries

SELECT common_name
FROM (
SELECT DISTINCT common_name, 'thailand' AS country FROM thailand
UNION
SELECT DISTINCT common_name, 'indonesia' FROM indonesia
UNION
SELECT DISTINCT common_name, 'philippines' FROM philippines
) AS all_data
GROUP BY common_name
HAVING COUNT(DISTINCT country) = 3;

-- Species exclusive to one country

SELECT us.common_name, fd.country
FROM (
SELECT common_name
FROM (
SELECT DISTINCT common_name, 'thailand' AS country FROM thailand
UNION
SELECT DISTINCT common_name, 'indonesia' AS country FROM indonesia
UNION
SELECT DISTINCT common_name, 'philippines' AS country FROM philippines
) AS all_data
GROUP BY common_name
HAVING COUNT(DISTINCT country) = 1
) AS us
JOIN (
SELECT DISTINCT common_name, 'thailand' AS country FROM thailand
UNION
SELECT DISTINCT common_name, 'indonesia' AS country FROM indonesia
UNION
SELECT DISTINCT common_name, 'philippines' AS country FROM philippines
) AS fd
ON us.common_name = fd.common_name;

-- First and last observation date per species

SELECT common_name, MIN(date) AS first_observation, MAX(date) AS last_observation
FROM (
SELECT common_name, date FROM thailand
UNION ALL
SELECT common_name, date FROM indonesia
UNION ALL
SELECT common_name, date FROM philippines
) AS all_obs
GROUP BY common_name
ORDER BY first_observation;

-- Total unique species per country

SELECT country, COUNT(DISTINCT common_name) AS unique_species
FROM (
SELECT country, common_name FROM thailand
UNION ALL
SELECT country, common_name FROM indonesia
UNION ALL
SELECT country, common_name FROM philippines
) AS all_data
GROUP BY country
ORDER BY unique_species DESC;

-- Species observed only once (all countries)

SELECT common_name, country, COUNT(*) AS total_observations
FROM (
SELECT common_name, country FROM thailand
UNION ALL
SELECT common_name, country FROM indonesia
UNION ALL
SELECT common_name, country FROM philippines
) AS all_obs
GROUP BY common_name, country
HAVING total_observations = 1;

-- Where are the hotspots of biodiversity?

SELECT country, ROUND(latitude, 1) AS lat_group, ROUND(longitude, 1) AS lon_group,
COUNT(DISTINCT common_name) AS unique_species
FROM (
SELECT country, latitude, longitude, common_name FROM thailand
UNION ALL
SELECT country, latitude, longitude, common_name FROM indonesia
UNION ALL
SELECT country, latitude, longitude, common_name FROM philippines
) AS all_data
GROUP BY country, lat_group, lon_group
ORDER BY unique_species DESC
LIMIT 20;

-- What species appear only in certain months?

SELECT common_name, MONTH(date) AS month, COUNT(*) AS total_observations
FROM (
SELECT common_name, date FROM thailand
UNION ALL
SELECT common_name, date FROM indonesia
UNION ALL
SELECT common_name, date FROM philippines
) AS all_obs
GROUP BY common_name, month
HAVING COUNT(*) = 1
ORDER BY common_name;

-- Top observed species by location (lat/lon)

SELECT common_name, ROUND(latitude, 2) AS lat, ROUND(longitude, 2) AS lon, COUNT(*) AS total
FROM (
SELECT common_name, latitude, longitude FROM thailand
UNION ALL
SELECT common_name, latitude, longitude FROM indonesia
UNION ALL
SELECT common_name, latitude, longitude FROM philippines
) AS all_data
GROUP BY common_name, lat, lon
ORDER BY total DESC
LIMIT 50;

-- Top observation species per country

SELECT country, common_name, COUNT(*) AS total_observations
FROM (
SELECT common_name, country FROM thailand
UNION ALL
SELECT common_name, country FROM indonesia
UNION ALL
SELECT common_name, country FROM philippines
) AS all_obs
GROUP BY country, common_name
ORDER BY country, total_observations DESC;