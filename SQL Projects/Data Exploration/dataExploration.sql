SELECT *
FROM portfolioProject.CovidDeaths;

SELECT *
FROM portfolioProject.CovidVaccinations;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM portfolioProject.CovidDeaths
ORDER BY 1,2;

# Looking at Total Cases vs. Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/CovidDeaths.total_cases)*100 as DeathPercentage
FROM portfolioProject.CovidDeaths
WHERE continent is NOT NULL
ORDER BY 1,2;

# What Percentage of population got COVID
SELECT location,
       date,
       population,
       total_cases,
       (CovidDeaths.total_cases/CovidDeaths.population)*100 as PercentPopulationInfected
FROM portfolioProject.CovidDeaths
WHERE location like '%germany%'
ORDER BY 1,2;

# Countries with Highest Infection Rate compared to Population
SELECT location,
       population,
       MAX(total_cases) as HighestInfectionCount,
       MAX((CovidDeaths.total_cases/CovidDeaths.population))*100 as PercentPopulationInfected
FROM portfolioProject.CovidDeaths
WHERE continent is NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected desc;

# Countries with the Highest Death Count/Population
SELECT location, MAX(CAST(total_deaths as UNSIGNED)) as TotalDeathCount
FROM portfolioProject.CovidDeaths
WHERE continent is NOT NULL
GROUP BY location
ORDER BY TotalDeathCount desc;

# Continents with the Highest Death Count/Population
SELECT continent, MAX(CAST(total_deaths as UNSIGNED)) as TotalDeathCount
FROM portfolioProject.CovidDeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount desc;

# GLOBAL DATA

# DeathPercentage/Day
SELECT date,
       SUM(new_cases) as TotalCases,
       SUM(new_deaths) as TotalDeaths,
       (SUM(new_deaths)/SUM(new_cases))*100 as DeathPercentage
FROM portfolioProject.CovidDeaths
WHERE continent is NOT NULL
GROUP BY date
ORDER BY 1,2;

# Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations)
    OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM portfolioProject.CovidDeaths dea
JOIN portfolioProject.CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is NOT NULL
ORDER BY 2,3;

# Using CTE
WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
    AS (SELECT dea.continent,
               dea.location,
               dea.date,
               dea.population,
               vac.new_vaccinations,
               SUM(vac.new_vaccinations)
                   OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
        FROM portfolioProject.CovidDeaths dea
                 JOIN portfolioProject.CovidVaccinations vac
                      ON dea.location = vac.location
                          AND dea.date = vac.date
        WHERE dea.continent is NOT NULL
        )
SELECT  *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac;

# Creating Views
CREATE VIEW portfolioProject.PercentPopulationVaccinated as
    SELECT dea.continent,
               dea.location,
               dea.date,
               dea.population,
               vac.new_vaccinations,
               SUM(vac.new_vaccinations)
                   OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
        FROM portfolioProject.CovidDeaths dea
                 JOIN portfolioProject.CovidVaccinations vac
                      ON dea.location = vac.location
                          AND dea.date = vac.date
        WHERE dea.continent is NOT NULL
        ORDER BY 2,3;


