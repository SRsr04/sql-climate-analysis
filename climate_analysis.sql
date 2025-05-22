-- Preview the data
SELECT * 
FROM state_climate
LIMIT 5;

-- Running average temperature (Fahrenheit) for each state by year
SELECT 
  state, 
  year,
  tempf,
  tempc, 
  AVG(tempf) OVER (
    PARTITION BY state
    ORDER BY year
  ) AS running_avg_temp
FROM state_climate
LIMIT 5;

-- Lowest temperature recorded for each state
SELECT 
  state, 
  year,
  tempf, 
  MIN(tempf) OVER (
    PARTITION BY state
  ) AS lowest
FROM state_climate
LIMIT 5;

-- Highest temperature recorded for each state
SELECT 
  state, 
  year,
  tempf, 
  MAX(tempf) OVER (
    PARTITION BY state
  ) AS highest
FROM state_climate
LIMIT 5;

-- Change in temperature from the previous year for each state
SELECT 
  state, 
  year,
  tempf, 
  tempf - LAG(tempf, 1, tempf) OVER (
    PARTITION BY state
    ORDER BY year
  ) AS temp_change
FROM state_climate
LIMIT 5;

-- Rank of the coldest temperatures on record (overall)
SELECT 
  year,
  state,
  tempf, 
  RANK() OVER (
    ORDER BY tempf ASC
  ) AS rank_coldest
FROM state_climate
LIMIT 5;

-- Rank of the hottest temperatures on record (overall)
SELECT 
  year,
  state,
  tempf, 
  RANK() OVER (
    ORDER BY tempf DESC
  ) AS rank_hottest
FROM state_climate
LIMIT 5;

-- Quartile of average yearly temperature for each state
SELECT
  state,
  year,
  avg_tempf,
  NTILE(4) OVER (
    PARTITION BY state
    ORDER BY avg_tempf ASC
  ) AS quartile
FROM (
  SELECT
    state,
    year,
    AVG(tempf) AS avg_tempf
  FROM state_climate
  GROUP BY state, year
) AS yearly_avg
LIMIT 5;

-- Quintile of average yearly temperature (overall, not by state)
SELECT
  year,
  state,
  avg_tempf,
  NTILE(5) OVER (
    ORDER
