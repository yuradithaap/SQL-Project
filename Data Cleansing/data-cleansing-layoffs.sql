SELECT * FROM layoffs;

-- Layoffs Staging
-- Kita mau ubah staging dari data
-- Kalo ada something mistake, data sebelumnya ga ilang

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT layoffs_staging 
SELECT * 
FROM layoffs;

-- DATA CLEANSING-- 
-- 1. Cek semua nomor baris, kalo ada yang lebih dari 1 maka itu duplikat
-- Gunakan row number dan partition
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- 2. Membuat table sementara untuk menyimpan data yang ada row num nya
WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, 
`date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging)
SELECT * FROM
duplicate_cte
WHERE row_num > 1;

-- 3. Karna kita mau hapus row_num > 1, maka kita harus bikin table baru yang ada row_num nya
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

-- 4. Masukin data ke table baru
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, 
date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- 5. Hapus data duplikat
DELETE FROM layoffs_staging2 WHERE row_num > 1;

SELECT * FROM layoffs_staging2 WHERE row_num >1;

-- STANDARDIZING DATA --
-- Mencari issue di dalam data dan perbaiki
-- Tips: Cari setiap kolom siapa tau ada issue

-- 1. Remove Whitespace
SET SQL_SAFE_UPDATES = 0;
UPDATE layoffs_staging2 
SET company = TRIM(company);

-- 2. Rename the Similar Data
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

SELECT distinct(location)
FROM layoffs_staging2
ORDER BY 1;

-- 3. Change DATE data type
UPDATE layoffs_staging2
SET `date` = str_to_date(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- REMOVE BLANK OR NULL DATA --
-- Check null or blank
SELECT * 
FROM layoffs_staging2
WHERE industry IS NULL OR industry = '';

-- Update blank into null
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Change null into populating data (data lain yang mirip dan tidak null)
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

-- Delete null data if the data is unconvincing
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- REMOVE UNNECESSARY COLUMNS --
ALTER TABLE layoffs_staging2
DROP row_num;

SELECT *
FROM layoffs_staging2;




