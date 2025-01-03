SELECT * FROM layoffs;

-- LAYOFFS STAGING --
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT layoffs_staging 
SELECT * 
FROM layoffs;

-- DATA CLEANSING--
-- 1. CHECK DUPLICATE --
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging)
SELECT * FROM
duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, 
date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- 2. DELETE DUPLICATE --
DELETE FROM layoffs_staging2 WHERE row_num > 1;

-- STANDARDIZING DATA --
-- Find the issues

-- 1. REMOVE WHITESPACES --
SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging2 
SET company = TRIM(company);

-- 2. RENAME DATA --
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

SELECT distinct(location)
FROM layoffs_staging2
ORDER BY 1;

-- 3. CHANGE DATA TYPES --
UPDATE layoffs_staging2
SET `date` = str_to_date(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- REMOVE BLANK OR NULL DATA --
-- 1. CHECK BLANK OR NULL --
SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL OR industry = '';

-- 2. UPDATE BLANK INTO NULL --
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- 3. FILL NULL USING POPULATION DATA --
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2. location
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL OR industry = '';

-- 3. DELETE NULL DATA --
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- 4. REMOVE UNNECESSARY COLUMNS --
ALTER TABLE layoffs_staging2
DROP row_num;

SELECT *
FROM layoffs_staging2;




