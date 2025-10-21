-- SQL Retail Sales Analysis
CREATE DATABASE sql_project_p1;
USE sql_project_p1;
SELECT YEAR(sale_date) AS year FROM retail_sales;
-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales 
	(	
			transactions_id	 INT PRIMARY KEY,
			sale_date	DATE,
			sale_time	TIME,
			customer_id	INT,
			gender	CHAR(6),
			age	TINYINT,
			category VARCHAR (15),	
			quantiy	INT,
            price_per_unit	FLOAT (5,2),
			cogs	FLOAT (5,2),
			total_sale FLOAT(6,2)
	);
	DROP TABLE retail_sales;
    SELECT * FROM retail_sales;
    SELECT COUNT(*) FROM retail_sales;
    
-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
    
-- Data Exploration
-- How many sales we have

SELECT COUNT(*) AS "Total Retail Sales" FROM retail_sales;

-- How many unique customers we have
SELECT COUNT(distinct(customer_id)) AS 'Total Customers' FROM retail_sales;   

-- How mamy categories we have

SELECT DISTINCT(category)  FROM retail_sales;

-- Data Analysis & Business Key Problems & Answesrs
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05**:

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
   
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND
DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
AND quantiy >= 4 ;
   
-- 3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:

SELECT 
	category,
	SUM(total_sale) AS net_sale
FROM retail_sales 
GROUP BY 1;

-- 4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:

SELECT 
category,
ROUND(AVG(age),2) AS Avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:

SELECT * FROM retail_sales
WHERE total_sale >1000;

-- 6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:

SELECT 
category,
gender,
COUNT(transactions_id) AS total_no_of_transactions
FROM retail_sales
GROUP BY category,gender
ORDER BY 1;

-- 7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:

SELECT * FROM
(SELECT 
	YEAR(sale_date) AS year,
    MONTH(sale_date) AS month, 
    AVG(total_sale) AS avg_sale,
    RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS ranking
FROM retail_sales
GROUP BY 1,2) AS t1 
WHERE ranking = 1;


-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT DISTINCT(customer_id),SUM(total_sale) AS total_sale FROM retail_sales
GROUP BY customer_id 
ORDER BY total_sale DESC
LIMIT 5;

-- 9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:

SELECT category,COUNT(DISTINCT(customer_id)) AS count_of_unique_customers FROM retail_sales
GROUP BY 1;


-- 10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:

WITH hourly_sale
AS
	(SELECT *, 
		CASE 
			WHEN HOUR (sale_time) < 12 THEN 'Morning' 
			WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift
	FROM retail_sales)
SELECT 
		shift,
        count(*) AS total_orders
FROM   hourly_sale     
GROUP BY shift;

-- End of project

    
