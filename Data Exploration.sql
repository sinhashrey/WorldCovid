SELECT *
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 3, 4;

SELECT *
FROM covidvaccinations
WHERE continent IS NOT NULL
ORDER BY 3,4;

-- Selecting the data for using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Calculating death %
-- Shows Covid mortality rate for Hong Kong
SELECT location,
       date,
       total_cases,
       total_deaths,
       (total_deaths / coviddeaths.total_cases) * 100 AS DeathPercent
FROM coviddeaths
WHERE location LIKE '%kong%'
  AND continent IS NOT NULL
ORDER BY 1, 2;

-- Total Cases vs Population for Hong Kong
SELECT location,
       date,
       population,
       total_cases,
       (coviddeaths.total_cases / coviddeaths.population) * 100 AS InfectionPercent
FROM coviddeaths
WHERE location LIKE '%kong%'
  AND continent IS NOT NULL
ORDER BY 1, 2;

-- Countries with Highest Infection Percentage
SELECT location,
       population,
       max(total_cases)                                              AS TotalCases,
       max((coviddeaths.total_cases / coviddeaths.population)) * 100 AS InfectionPercent
FROM coviddeaths
-- WHERE location LIKE '%kong%'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY InfectionPercent DESC;

-- Countries with Highest Death Percentage
SELECT location,
       max(total_deaths) AS TotalDeaths
FROM coviddeaths
-- WHERE location LIKE '%kong%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeaths DESC;

-- Global Numbers
SELECT sum(new_cases)                         AS TotalCases,
       sum(new_deaths)                        AS TotalDeaths,
       sum(new_deaths) / sum(new_cases) * 100 AS DeathPercent
FROM coviddeaths
-- WHERE location LIKE '%kong%'
WHERE continent IS NOT NULL
-- GROUP BY date
ORDER BY 1, 2;

-- Population vs Vaccinations
WITH PopVac (continent, location, date, population, new_vaccinations, RollingVaccinations)
AS 
(
    SELECT dea.continent,
           dea.location,
           dea.date,
           dea.population,
           vac.new_vaccinations,
           sum(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinations
    FROM coviddeaths dea
             INNER JOIN covidvaccinations vac
                        ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
    ORDER BY 2, 3
)
SELECT *, (RollingVaccinations/population)*100 AS RollingPercentVaccinated
FROM PopVac;