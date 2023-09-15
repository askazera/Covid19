-- DATA BASE SCHEMA 

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'deaths'

-- Visualizing all table
SELECT * FROM PortfolioProject..deaths

-- Viewing continents and locations only once to check for missing data
SELECT DISTINCT continent, location
FROM PortfolioProject..deaths

-- Visualizing the values of deaths and cases by location, date and population
SELECT location, date, total_cases, new_cases, total_deaths, new_deaths, population
FROM PortfolioProject..deaths
ORDER BY 1,2

-- CONTANDO NAN E NULL 
SELECT COUNT(*) AS Total_NaN
FROM PortfolioProject..deaths
WHERE continent = 'NaN' OR continent = '';


SELECT COUNT(*) AS Total_Null
FROM PortfolioProject..deaths
WHERE continent IS NULL;

-- Total de mortes sobre o total de casos, em porcentagem
-- We used MAX because the values of the columns are culmulative
SELECT
    location,
    MAX(CAST(total_deaths AS float)) AS MaxTotalDeaths, 
    MAX(CAST(total_deaths AS float) / CAST(total_cases AS float))*100 AS DeathsPercentage
FROM PortfolioProject..deaths
WHERE continent <> 'NaN' AND continent <> '' AND continent IS NOT NULL
GROUP BY location,date
ORDER BY MaxTotaldeaths DESC


-- Countries with the highest cases of infected people and their percentage of population size
SELECT
    location,
	population,
    MAX(CAST(total_cases AS float)) AS MaxTotalCases, 
    MAX(CAST(total_cases AS float) / CAST(population AS float))*100 AS MaxInfectedPercentage
FROM PortfolioProject..deaths
WHERE continent <> 'NaN' AND continent <> '' AND continent IS NOT NULL -- where continent is different from NaN, '' and is not null
GROUP BY location, population
ORDER BY MaxInfectedPercentage DESC

-- Total infected by country
SELECT
    location,
    MAX(CAST(total_cases AS FLOAT)) AS MaxTotalCases
FROM PortfolioProject..deaths
WHERE continent <> 'NaN' AND continent <> '' AND continent IS NOT NULL
GROUP BY location
ORDER BY MaxTotalCases DESC


-- sum of total cases in the world
SELECT
    SUM(MaxTotalCases) AS TotalMaxTotalCases
FROM (
    SELECT
		location,
        MAX(CAST(total_cases AS FLOAT)) AS MaxTotalCases
    FROM PortfolioProject..deaths
	GROUP BY location
) AS Subconsulta

-- total deaths in the world, we add all the maximum values
SELECT
    SUM(MaxTotalDeaths) AS TotalMaxTotalDeaths
FROM (
    SELECT
	    location,
        MAX(CAST(total_deaths AS int)) AS MaxTotalDeaths
    FROM PortfolioProject..deaths
    WHERE continent <> 'NaN' AND continent <> '' AND continent IS NOT NULL
    GROUP BY location
) AS Subconsulta


-- sum of total people who took at least one dose of the vaccine
SELECT
    SUM(MaxPeopleVaccinated) AS TotalMaxPeopleVaccinated
FROM (
    SELECT
		location,
        MAX(CAST(people_vaccinated AS FLOAT)) AS MaxPeopleVaccinated
    FROM PortfolioProject..deaths
	WHERE continent <> 'NaN' AND continent <> '' AND continent IS NOT NULL
	GROUP BY location
) AS Subconsulta

-- Total deaths by country
SELECT
    location,
    MAX(CAST(total_deaths AS INT)) AS MaxTotalDeaths
FROM PortfolioProject..deaths
WHERE continent <> 'NaN' AND continent <> '' AND continent IS NOT NULL--retirar location com continente vazio
GROUP BY location
ORDER BY MaxTotalDeaths DESC

Select location, SUM(cast(new_cases as int)) as TotalDeathCount
From PortfolioProject..sheet
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International','High income', 'Lower middle income','Upper middle income','Low income' )
Group by location
order by TotalDeathCount desc

-- Total deaths by continent
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalDeaths
FROM PortfolioProject..deaths
--WHERE continent <> 'NaN' AND continent <> '' AND continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeaths DESC

--total deaths per year and percentages of total cases
SELECT
    YEAR(date) AS Year,
    MAX(CAST(total_deaths AS float)) AS TotalDeaths,
    MAX(CAST(total_deaths AS float) / CAST(total_cases AS float))*100 AS DeathsPercentage
FROM PortfolioProject..deaths
WHERE continent <> 'NaN' AND continent <> '' AND continent IS NOT NULL
GROUP BY YEAR(date)
ORDER BY Year DESC

-- total deaths per year
SELECT
    YEAR(date) AS Year,
    SUM(CAST(new_deaths AS float)) AS TotalDeaths
FROM PortfolioProject..deaths
WHERE continent <> 'NaN' AND continent <> '' AND continent IS NOT NULL
GROUP BY YEAR(date)
ORDER BY TotalDeaths DESC


-- Total Deaths and Total New Cases from 2020 to 2023SELECT
	location,
    SUM(CAST(new_deaths AS float)) AS TotalDeaths,
	SUM(CAST(new_cases AS float)) AS TotalCases
FROM PortfolioProject..deaths
WHERE continent <> 'NaN' AND continent <> '' AND continent IS NOT NULL
GROUP BY location
ORDER BY 1,2

-- VACCINES
-- People who have received at least one dose of vaccine
SELECT location, population, MAX(CAST(people_vaccinated as float)) as TotalVaccination
FROM PortfolioProject..deaths
GROUP BY location, population
order by TotalVaccination DESC

-- Total doses administered by country
SELECT location, MAX(CAST(total_vaccinations as float)) as TotalDosesAdministrated
FROM PortfolioProject..deaths
GROUP BY location
order by TotalDosesAdministrated DESC

-- people fully vaccinated by country
SELECT location, MAX(CAST(people_fully_vaccinated as float)) as PeopleFullyVaccinated
FROM PortfolioProject..deaths
GROUP BY location
order by PeopleFullyVaccinated DESC

--Creating a table to test 
CREATE TABLE PortfolioProject..covid_data (
    date datetime,
    continent varchar(255),
    location varchar(255),
    population float,
    total_cases float,
    new_cases float,
    total_deaths float,
    new_deaths float,
    total_cases_per_million float,
    new_cases_per_million float,
    total_deaths_per_million float,
    new_deaths_per_million float,
    reproduction_rate float,
    icu_patients float,
    total_tests float,
    new_tests float,
    positive_rate float,
    tests_units varchar(255),
    total_vaccinations float,
    people_fully_vaccinated float,
    total_boosters float,
    new_vaccinations float,
    total_vaccinations_per_hundred float,
    people_vaccinated_per_hundred float,
    people_fully_vaccinated_per_hundred float,
    median_age float,
    aged_65_older float,
    aged_70_older float,
    gdp_per_capita float,
    cardiovasc_death_rate float,
    diabetes_prevalence float,
    female_smokers float,
    male_smokers float,
    handwashing_facilities float,
    life_expectancy float

)

--Inserting the atributes into the table
INSERT INTO PortfolioProject..covid_data (
    date, 
    continent, 
    location, 
    population, 
    total_cases, 
    new_cases, 
    total_deaths, 
    new_deaths, 
    total_cases_per_million, 
    new_cases_per_million, 
    total_deaths_per_million, 
    new_deaths_per_million, 
    reproduction_rate, 
    icu_patients, 
    total_tests, 
    new_tests, 
    positive_rate, 
    tests_units, 
    total_vaccinations, 
    people_fully_vaccinated, 
    total_boosters, 
    new_vaccinations, 
    total_vaccinations_per_hundred, 
    people_vaccinated_per_hundred, 
    people_fully_vaccinated_per_hundred, 
    median_age, 
    aged_65_older, 
    aged_70_older, 
    gdp_per_capita, 
    cardiovasc_death_rate, 
    diabetes_prevalence, 
    female_smokers, 
    male_smokers, 
    handwashing_facilities, 
    life_expectancy
)
SELECT 
    CAST(date AS datetime), 
    CAST(continent AS varchar), 
    CAST(location AS varchar), 
    CAST(population AS float), 
    CAST(total_cases AS float), 
    CAST(new_cases AS float), 
    CAST(total_deaths AS float), 
    CAST(new_deaths AS float), 
    CAST(total_cases_per_million AS float), 
    CAST(new_cases_per_million AS float), 
    CAST(total_deaths_per_million AS float), 
    CAST(new_deaths_per_million AS float), 
    CAST(reproduction_rate AS float), 
    CAST(icu_patients AS float), 
    CAST(total_tests AS float), 
    CAST(new_tests AS float), 
    CAST(positive_rate AS float), 
    CAST(tests_units AS varchar), 
    CAST(total_vaccinations AS float), 
    CAST(people_fully_vaccinated AS float), 
    CAST(total_boosters AS float), 
    CAST(new_vaccinations AS float), 
    CAST(total_vaccinations_per_hundred AS float), 
    CAST(people_vaccinated_per_hundred AS float), 
    CAST(people_fully_vaccinated_per_hundred AS float), 
    CAST(median_age AS float), 
    CAST(aged_65_older AS float), 
    CAST(aged_70_older AS float), 
    CAST(gdp_per_capita AS float), 
    CAST(cardiovasc_death_rate AS float), 
    CAST(diabetes_prevalence AS float), 
    CAST(female_smokers AS float), 
    CAST(male_smokers AS float), 
    CAST(handwashing_facilities AS float), 
    CAST(life_expectancy AS float)
FROM PortfolioProject..deaths

--Visualizing the new table
SELECT * FROM PortfolioProject..covid_data

--SCHEMA
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'PortfolioProject'
  AND TABLE_NAME = 'covid_data';


-- total number of people vaccinated in the world
SELECT SUM(people_fully_vaccinated) as total_people_fully_vaccinated
FROM (
    SELECT
        MAX(CAST(people_fully_vaccinated AS FLOAT)) AS people_fully_vaccinated
    FROM PortfolioProject..covid_data
    WHERE continent <> 'NaN' AND continent <> '' AND continent IS NOT NULL
    GROUP BY location
) subquery



    
