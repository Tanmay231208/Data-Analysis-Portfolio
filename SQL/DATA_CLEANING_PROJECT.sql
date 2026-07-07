-- Data Cleaning

-- Creating a Working Sheet

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;

SELECT * 
FROM layoffs_staging;

-- Removing Duplicates

WITH duplicates_cte AS
(SELECT *,ROW_NUMBER() 
OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,
`date`,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicates_cte
WHERE row_num > 1  
;

SELECT * 
FROM layoffs_staging
WHERE company = "Cazoo" ;

-- Creating another table to permanently add row_num column and remove duplicates

CREATE TABLE `layoffs_staging` (
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

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,ROW_NUMBER() 
OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,
`date`,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num >1;

-- Standardising data 
SELECT *
FROM layoffs_staging2;

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = "United States"
WHERE country LIKE "United States%";


-- Fixing Dates

SELECT `date`,
STR_TO_DATE(`date`, "%m/%d/%Y")
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, "%m/%d/%Y");

SELECT * 
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Fixing Null/Blank Values

-- Fixing Null Industries

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = "";

SELECT * 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;

--  Deleting records where total laid off and percentage laid off is null

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs_staging2;

-- Droping row_num

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;





























