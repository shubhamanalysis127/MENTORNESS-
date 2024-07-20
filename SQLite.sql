-- 1. Checking for null values:

SELECT COUNT(*) as null_count
FROM CoronaVirusDataset
WHERE Province IS NULL OR Country_Region IS NULL OR Latitude IS NULL OR Longitude IS NULL
   OR Date IS NULL OR Confirmed IS NULL OR Deaths IS NULL OR Recovered IS NULL;







-- 2. Replacing null values with 0 for numeric columns:

UPDATE CoronaVirusDataset
SET Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0);
DELETE FROM CoronaVirusDataset
WHERE rowid = (SELECT MIN(rowid) FROM CoronaVirusDataset);



-- 3. Count total rows:

SELECT COUNT(*) as total_rows FROM CoronaVirusDataset;







-- 4. Find date range:

SELECT MIN(Date) as start_date, MAX(Date) as end_date
FROM CoronaVirusDataset;




-- 5. Number of months in dataset:

SELECT COUNT(DISTINCT substr(Date, 4, 2)) as month_count
FROM CoronaVirusDataset;





-- 6. Monthly averages:

SELECT substr(Date, 4, 2) as month,
       AVG(Confirmed) as avg_confirmed,
       AVG(Deaths) as avg_deaths,
       AVG(Recovered) as avg_recovered
FROM CoronaVirusDataset
GROUP BY substr(Date, 4, 2)
ORDER BY month;


-- 7. Most frequent values per month:
WITH monthly_mode AS (
    SELECT substr(Date, 4, 2) as month,
           Confirmed, Deaths, Recovered,
           ROW_NUMBER() OVER (PARTITION BY substr(Date, 4, 2)
                              ORDER BY COUNT(*) DESC) as rn
    FROM CoronaVirusDataset
    GROUP BY substr(Date, 4, 2), Confirmed, Deaths, Recovered
)
SELECT month, Confirmed, Deaths, Recovered
FROM monthly_mode
WHERE rn = 1
ORDER BY month;


-- 8. Minimum values per month:

SELECT substr(Date, 4, 2) as month,
       MIN(Confirmed) as min_confirmed,
       MIN(Deaths) as min_deaths,
       MIN(Recovered) as min_recovered
FROM CoronaVirusDataset
GROUP BY substr(Date, 4, 2)
ORDER BY month;


-- 9. Maximum values per month:

SELECT substr(Date, 4, 2) as month,
       MAX(Confirmed) as max_confirmed,
       MAX(Deaths) as max_deaths,
       MAX(Recovered) as max_recovered
FROM CoronaVirusDataset
GROUP BY substr(Date, 4, 2)
ORDER BY month;


-- 10. Monthly totals:

SELECT substr(Date, 4, 2) as month,
       SUM(Confirmed) as total_confirmed,
       SUM(Deaths) as total_deaths,
       SUM(Recovered) as total_recovered
FROM CoronaVirusDataset
GROUP BY substr(Date, 4, 2)
ORDER BY month;


-- 11. Spread of confirmed cases:

SELECT SUM(Confirmed) as total_confirmed,
       AVG(Confirmed) as avg_confirmed,
       (AVG(Confirmed * Confirmed) - AVG(Confirmed) * AVG(Confirmed)) as var_confirmed,
       SQRT(AVG(Confirmed * Confirmed) - AVG(Confirmed) * AVG(Confirmed)) as stddev_confirmed
FROM CoronaVirusDataset;




-- 12. Spread of death cases per month:

SELECT substr(Date, 4, 2) as month,
       SUM(Deaths) as total_deaths,
       AVG(Deaths) as avg_deaths,
       (AVG(Deaths * Deaths) - AVG(Deaths) * AVG(Deaths)) as var_deaths,
       SQRT(AVG(Deaths * Deaths) - AVG(Deaths) * AVG(Deaths)) as stddev_deaths
FROM CoronaVirusDataset
GROUP BY substr(Date, 4, 2)
ORDER BY month;


-- 13. Spread of recovered cases:

SELECT SUM(Recovered) as total_recovered,
       AVG(Recovered) as avg_recovered,
       (AVG(Recovered * Recovered) - AVG(Recovered) * AVG(Recovered)) as var_recovered,
       SQRT(AVG(Recovered * Recovered) - AVG(Recovered) * AVG(Recovered)) as stddev_recovered
FROM CoronaVirusDataset;




-- 14. Country with highest confirmed cases:

SELECT Country_Region, SUM(Confirmed) as total_confirmed
FROM CoronaVirusDataset
GROUP BY Country_Region
ORDER BY total_confirmed DESC
LIMIT 1;



-- 15. Country with lowest non-zero death cases:

SELECT Country_Region, SUM(Deaths) as total_deaths
FROM CoronaVirusDataset
GROUP BY Country_Region
HAVING SUM(Deaths) > 0
ORDER BY total_deaths ASC
LIMIT 1;






-- 16. Top 5 countries with highest recovered cases:

SELECT Country_Region, SUM(Recovered) as total_recovered
FROM CoronaVirusDataset
GROUP BY Country_Region
ORDER BY total_recovered DESC
LIMIT 5;

