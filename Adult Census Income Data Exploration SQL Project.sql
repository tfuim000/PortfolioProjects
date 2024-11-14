*/

Adult Census Income (1994) Cleaning / Exploratory Data Analysis

*/


SELECT * 
FROM adult_census_income

---- Data Cleaning ----

---Replace all '?' with NULL

--workclass (1836)

SELECT DISTINCT(workclass), COUNT(workclass)
FROM AdultCensusIncomeProject..adult_census_income
GROUP BY workclass
ORDER BY 2 DESC

SELECT workclass,
	CASE WHEN workclass = '?' THEN NULL
	ELSE workclass
	END
FROM AdultCensusIncomeProject..adult_census_income


UPDATE adult_census_income
SET workclass = CASE WHEN workclass = '?' THEN NULL
	ELSE workclass
	END
FROM AdultCensusIncomeProject..adult_census_income

SELECT COUNT(*)
FROM AdultCensusIncomeProject..adult_census_income
WHERE workclass IS NULL 

--occupation (1843)

SELECT DISTINCT(occupation), COUNT(occupation) AS number_of_workers
FROM AdultCensusIncomeProject..adult_census_income
GROUP BY occupation
ORDER BY 2 DESC

SELECT occupation,
	CASE WHEN occupation = '?' THEN NULL
	ELSE occupation
	END
FROM AdultCensusIncomeProject..adult_census_income

UPDATE adult_census_income
SET occupation = CASE WHEN occupation = '?' THEN NULL
	ELSE occupation
	END
FROM AdultCensusIncomeProject..adult_census_income

SELECT COUNT(*)
FROM AdultCensusIncomeProject..adult_census_income
WHERE occupation IS NULL 

--native country (583)

SELECT DISTINCT(native_country), COUNT(native_country)
FROM AdultCensusIncomeProject..adult_census_income
GROUP BY native_country
ORDER BY 2 DESC

SELECT native_country,
	CASE WHEN native_country = '?' THEN NULL
	ELSE native_country
	END
FROM AdultCensusIncomeProject..adult_census_income


UPDATE adult_census_income
SET native_country = CASE WHEN native_country = '?' THEN NULL
	ELSE native_country
	END
FROM AdultCensusIncomeProject..adult_census_income


SELECT COUNT(*)
FROM AdultCensusIncomeProject..adult_census_income
WHERE native_country IS NULL 

--- Changing "Hong" to "Hong-Kong"
--- Though not a separate country, I still wanted to acknowledge its independence and not skew the data by combining it with China

SELECT DISTINCT native_country
FROM AdultCensusIncomeProject..adult_census_income
WHERE native_country IS NOT NULL

SELECT * 
FROM AdultCensusIncomeProject..adult_census_income
WHERE native_country = 'Hong'

SELECT native_country,
	CASE WHEN native_country = 'Hong' THEN 'Hong-Kong'
	ELSE native_country
	END
FROM AdultCensusIncomeProject..adult_census_income

UPDATE adult_census_income
SET native_country = CASE WHEN native_country = 'Hong' THEN 'Hong-Kong'
	ELSE native_country
	END
FROM AdultCensusIncomeProject..adult_census_income


---------------------------------------------------
----Percentage of HS graduates that make >50k

SELECT COUNT(*) AS total_hsgrads
FROM adult_census_income
WHERE  education = 'HS-grad'

--10501 total hs grad

SELECT COUNT(*) AS totalgrads_over50 
FROM adult_census_income
WHERE  education = 'HS-grad'
AND income = '>50k'

--1675 are hs grads and make over 50k

SELECT ROUND(100 * (CAST((SELECT COUNT(*) 
	FROM adult_census_income WHERE  education = 'HS-grad'
	AND income = '>50k')AS FLOAT))/(CAST((SELECT COUNT(*) AS total_hsgrads
	FROM adult_census_income WHERE  education = 'HS-grad')AS FLOAT)), 2) AS PercentHSGradsOver50k 
FROM AdultCensusIncomeProject..adult_census_income
	
--15.95% of HS grads make 50k

---- Percentage of folks who make over 50k----

SELECT ROUND(100 * (CAST((SELECT COUNT(*)
FROM AdultCensusIncomeProject..adult_census_income
WHERE income = '>50k')AS FLOAT))/(CAST((SELECT COUNT(*)
FROM AdultCensusIncomeProject..adult_census_income)AS FLOAT)), 0) AS PercentOver50k 
FROM AdultCensusIncomeProject..adult_census_income

---- Mean age of adults that make > 50k for each country----

SELECT native_country, AVG(age) AS avg_age
FROM AdultCensusIncomeProject..adult_census_income
WHERE income = '>50k'
AND native_country IS NOT NULL
GROUP BY native_country
ORDER BY 1

---- Education level of those who make > 50k----

SELECT education, COUNT(education) AS ed_count
FROM AdultCensusIncomeProject..adult_census_income
WHERE income = '>50k'
GROUP BY education
ORDER BY 2 DESC

---- Gender breakdown of those who make > 50k----

SELECT gender, COUNT(gender) AS gender_count
FROM AdultCensusIncomeProject..adult_census_income
WHERE income = '>50k'
GROUP BY gender
ORDER BY 2 DESC