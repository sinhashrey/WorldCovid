# Overall cases and Mortality Rate
SELECT SUM(new_cases)                                                                                    AS total_cases,
       SUM(new_deaths)                                                                                   AS total_deaths,
       SUM(new_deaths) / SUM(New_Cases)                                                                  AS DeathPercent,
       (SELECT max(people_vaccinated_per_hundred) / 100
        FROM covidvaccinations
        WHERE location = 'World')                                                                        AS VaccinatedPeoplePercent
FROM coviddeaths
         INNER JOIN covidvaccinations
                    ON covidvaccinations.location = coviddeaths.location AND covidvaccinations.date = coviddeaths.date
WHERE coviddeaths.continent IS NOT NULL;

# Deaths across Continents
SELECT continent, SUM(new_deaths) AS TotalDeaths
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeaths DESC;

# Percent of Infections by Countries
SELECT Location,
       Population,
       MAX(total_cases)                      AS NumberOfInfections,
       Max((total_cases / population)) * 100 AS PercentInfected
FROM coviddeaths
GROUP BY Location, Population
ORDER BY PercentInfected DESC;

# Percent of Infections by Countries and Date
SELECT Location,
       Population,
       date,
       MAX(total_cases)                      AS NumberOfInfections,
       Max((total_cases / population)) * 100 AS PercentInfected
FROM coviddeaths
GROUP BY Location, Population, date
ORDER BY PercentInfected DESC;

# Vaccinations per 100 and Dosage stats
SELECT covidvaccinations.location,
       (sum(new_vaccinations) / coviddeaths.population) * 100        AS VaccinationsPer100,
       (max(people_vaccinated) / coviddeaths.population) * 100       AS FirstDosagePercent,
       (max(people_fully_vaccinated) / coviddeaths.population) * 100 AS SecondDosagePercent,
       (max(total_boosters) / coviddeaths.population) * 100          AS BoosterDosagePercent
FROM covidvaccinations
         INNER JOIN coviddeaths
                    ON covidvaccinations.location = coviddeaths.location AND covidvaccinations.date = coviddeaths.date
WHERE covidvaccinations.continent IS NOT NULL
GROUP BY covidvaccinations.location
ORDER BY VaccinationsPer100 DESC;