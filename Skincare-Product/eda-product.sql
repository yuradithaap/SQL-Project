-- EXPLORATORY DATA ANALYSIS --
SELECT * FROM product_staging;

-- DATA SAMPLING --
SELECT * FROM product_staging
ORDER BY Product_Name ASC
LIMIT 5;

SELECT * FROM product_staging
ORDER BY Product_Name DESC
LIMIT 5;

SELECT * FROM product_staging
ORDER BY Rand()
LIMIT 5;

-- CHECK SIZE OF DATASET --
SELECT COUNT(*) FROM product_staging;

-- CHECK DATA TYPES --
DESCRIBE product_staging;

-- DISTRIBUTION OF PRODUCT_NAME --
SELECT *,ROUND((freq/SUM(freq) OVER())*100,2) AS percentage 
FROM (
  SELECT Product_Name,COUNT(Product_Name) AS freq 
  FROM product_staging
  GROUP BY Product_Name
  ORDER BY freq DESC
) AS Product;

-- DISTRIBUTION OF BRAND --
SELECT *,ROUND((freq/SUM(freq) OVER())*100,2) AS percentage 
FROM (
  SELECT Brand,COUNT(Brand) AS freq 
  FROM product_staging
  GROUP BY Brand
  ORDER BY freq DESC
) AS Product;

-- DISTRIBUTION OF CATEGORY --
SELECT *,ROUND((freq/SUM(freq) OVER())*100,2) AS percentage 
FROM (
  SELECT Category,COUNT(Category) AS freq 
  FROM product_staging
  GROUP BY Category
  ORDER BY freq DESC
) AS Product;

-- DISTRIBUTION OF USAGE FREQUENCY --
SELECT *,ROUND((freq/SUM(freq) OVER())*100,2) AS percentage 
FROM (
  SELECT Usage_Frequency,COUNT(Usage_Frequency) AS freq 
  FROM product_staging
  GROUP BY Usage_Frequency
  ORDER BY freq DESC
) AS Product;

-- PRICE --
SELECT 
	MIN(Price_USD) AS Min_Price,
    MAX(Price_USD) AS Max_Price,
    AVG(Price_USD) AS Avg_Price
FROM product_staging;

-- RATING --
SELECT 
	MIN(Rating) AS Min_Rating,
    MAX(Rating) AS Max_Rating,
    AVG(Rating) AS Avg_Rating
FROM product_staging;

-- NUMBER OF REVIEWS --
SELECT 
	MIN(Number_of_Reviews) AS Min_Review,
    MAX(Number_of_Reviews) AS Max_Review,
    AVG(Number_of_Reviews) AS Avg_Review
FROM product_staging;

-- DISTRIBUTION OF PRODUCT SIZE --
SELECT *,ROUND((freq/SUM(freq) OVER())*100,2) AS percentage 
FROM (
  SELECT Product_Size,COUNT(Product_Size) AS freq 
  FROM product_staging
  GROUP BY Product_Size
  ORDER BY freq DESC
) AS Product;

-- DISTRIBUTION OF SKIN TYPE --
SELECT *,ROUND((freq/SUM(freq) OVER())*100,2) AS percentage 
FROM (
  SELECT Skin_Type,COUNT(Skin_Type) AS freq 
  FROM product_staging
  GROUP BY Skin_Type
  ORDER BY freq DESC
) AS Product;

-- DISTRIBUTION OF GENDER --
SELECT *,ROUND((freq/SUM(freq) OVER())*100,2) AS percentage 
FROM (
  SELECT Gender_Target,COUNT(Gender_Target) AS freq 
  FROM product_staging
  GROUP BY Gender_Target
  ORDER BY freq DESC
) AS Product;

-- DISTRIBUTION OF PACKAGING --
SELECT *,ROUND((freq/SUM(freq) OVER())*100,2) AS percentage 
FROM (
  SELECT Packaging_Type,COUNT(Packaging_Type) AS freq 
  FROM product_staging
  GROUP BY Packaging_Type
  ORDER BY freq DESC
) AS Product;

-- DISTRIBUTION OF MAIN INGRIDIENTS --
SELECT *,ROUND((freq/SUM(freq) OVER())*100,2) AS percentage 
FROM (
  SELECT Main_Ingredient,COUNT(Main_Ingredient) AS freq 
  FROM product_staging
  GROUP BY Main_Ingredient
  ORDER BY freq DESC
) AS Product;

-- DISTRIBUTION OF CRUELTY FREE --
SELECT *,ROUND((freq/SUM(freq) OVER())*100,2) AS percentage 
FROM (
  SELECT Cruelty_Free,COUNT(Cruelty_Free) AS freq 
  FROM product_staging
  GROUP BY Cruelty_Free
  ORDER BY freq DESC
) AS Product;

-- DISTRIBUTION OF COUNTRY --
SELECT *,ROUND((freq/SUM(freq) OVER())*100,2) AS percentage 
FROM (
  SELECT Country_of_Origin,COUNT(Country_of_Origin) AS freq 
  FROM product_staging
  GROUP BY Country_of_Origin
  ORDER BY freq DESC
) AS Product;

-- PRICE BY BRAND & CATEGORY --
SELECT Brand, Category, ROUND(AVG(Price_USD),2) AS AVG_Price
FROM product_staging
GROUP BY Brand, Category
ORDER BY 3 DESC;

-- RATING BY CATEGORY --
SELECT Category, ROUND(AVG(Rating), 2) AS AVG_Rating
FROM product_staging
GROUP BY Category
ORDER BY 2 DESC;

-- PRODUCT BY REVIEWS --
SELECT Product_Name, ROUND(AVG(Number_of_Reviews),0) AS AVG_Review
FROM product_staging
GROUP BY Product_Name
ORDER BY 2 DESC;

-- THE HIGHEST PRICE PRODUCT --
SELECT Product_Name, Price_USD
FROM product_staging
WHERE Price_USD = (SELECT(MAX(Price_USD)) FROM product_staging);

-- THE LOWEST PRICE PRODUCT --
SELECT Product_Name, Price_USD
FROM product_staging
WHERE Price_USD = (SELECT(MIN(Price_USD)) FROM product_staging);

-- CATEGORY WITH RATING & PRICE --
SELECT Category, ROUND(AVG(Rating), 2) AS AVG_Rating, ROUND(AVG(Price_USD), 2) AS AVG_Price
FROM product_staging
GROUP BY Category
ORDER BY 2 DESC;

-- CATEGORY & SIZE --
SELECT Category, Product_Size, COUNT(*) AS Total_Products
FROM product_staging
GROUP BY Category, Product_Size
ORDER BY Total_Products DESC;

-- RATING BASED ON COUNTRY --
SELECT Country_of_Origin, ROUND(AVG(Rating),2) AS AVG_Rating
FROM product_staging
GROUP BY Country_of_Origin
ORDER BY Avg_Rating DESC;

-- TOP 10 BEST PRODUCT --
SELECT Product_Name, Brand, Category, 
ROUND(AVG(Rating),2) AS Rating, ROUND(AVG(Number_of_Reviews),2) AS Review
FROM product_staging
GROUP BY Product_Name, Brand, Category
ORDER BY 4 DESC LIMIT 10;

