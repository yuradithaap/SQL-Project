-- DATA STAGING --
CREATE TABLE product_staging
LIKE product;

INSERT product_staging
SELECT *
FROM product;

-- DATA CLEANSING --
SELECT * FROM product_staging;

-- CHECK DUPLICATE --
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Product_Name, Brand, Category, 
Usage_Frequency, Price_USD, Rating, Number_of_Reviews, 
Product_Size, Skin_Type, Gender_Target, 
Packaging_Type, Main_Ingredient, Cruelty_Free, Country_of_Origin) AS row_num
FROM product_staging;

WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Product_Name, Brand, Category, 
Usage_Frequency, Price_USD, Rating, Number_of_Reviews, 
Product_Size, Skin_Type, Gender_Target, 
Packaging_Type, Main_Ingredient, Cruelty_Free, Country_of_Origin) AS row_num
FROM product_staging)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- STANDARDIZING DATA --
SELECT DISTINCT(Country_of_Origin) 
FROM product_staging
ORDER BY 1 ASC;

-- REMOVE WHITESPACE --
UPDATE product_staging 
SET Product_Name = TRIM(Product_Name);

UPDATE product_staging 
SET Brand = TRIM(Brand);

-- CHECK NULL OR BLANK --
SELECT * 
FROM product_staging
WHERE Product_Name IS NULL AND Product_Name = '';




