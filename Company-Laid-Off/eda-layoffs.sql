-- EXPLORATORY DATA ANALYSIS --
SELECT * FROM layoffs_staging2;

-- TOTAL MAX LAID OFF & PERCENTAGE LAID OFF --
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- DATA WITH MAX PERCENTAGE LAID OFF --
SELECT * FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- TOTAL LAID OFF BY COMPANY --
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- MIN & MAX DATE LAID OFF --
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- TOTAL LAID OFF BY INDUSTRY --
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- TOTAL LAID OFF BY COUNTRY --
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- TOTAL LAID OFF BY DATE --
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
WHERE `date` IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- TOTAL LAID OFF BY STAGE --
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- TOTAL LAID OFF BY DATE --
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC;

-- ROLLING TOTAL --
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `Month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY 1 ASC)
SELECT `Month`, total_off, SUM(total_off) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_Total;

-- TOTAL LAID OFF COMPANY BY YEAR --
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- RANK LAID OFF PER YEAR --
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS `Ranking`
FROM Company_Year
WHERE years IS NOT NULL)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
ORDER BY years ASC;

-- TOTAL EMPLOYEE --
SELECT *, total_laid_off / percentage_laid_off AS total_employees
FROM layoffs_staging2;

-- PERCENTAGE LAID OFF PER STAGE --
SELECT stage, ROUND(AVG(percentage_laid_off),2), YEAR(`date`) AS year
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY stage, year
ORDER BY 2 DESC;




