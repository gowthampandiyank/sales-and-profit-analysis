-- create data base 
create database adidas;

-- selact database
use adidas;

-- alter table 
ALTER TABLE data_sales_adidas
RENAME TO adidas;

ALTER TABLE adidas
CHANGE catacri category VARCHAR(100);

select * from adidas;


-- 1.Display the first 10 rows from the Adidas sales table.
select * from adidas 
LIMIT 10;

-- 2.Find the total number of records in the dataset.
select count(*) from adidas;

-- 3.List all distinct product categories.
select distinct category
from adidas;

-- 4.Show all sales made in the West region.
SELECT SUM(total_sales) AS total_sales
FROM adidas
WHERE region = 'West';

-- 5.Find total sales across all regions.
select region, SUM(total_sales) as sales
from adidas
group by region;


-- 6.Calculate total units sold.
select category, count(units_sold)
from adidas
group by category;

-- 7.List all distinct sales methods.
select distinct sales_method
from adidas;

-- 8.Find the minimum, maximum, and average price per unit.
select 
min(price_per_unit) as minimun,
max(price_per_unit) as maximum,
avg(price_per_unit) as avarage
from adidas;

-- 9.Count how many unique retailers are present.
SELECT COUNT(DISTINCT retailer) AS total_unique_retailers
FROM adidas;

-- 10.Show all records where operating margin is greater than 40%.
select * from adidas
where operating_margin > 0.40;

-- 11.Find total sales by category.
select category,sum(total_sales) as sales
from adidas
group by category;

-- 12.Find total sales by region.
select region,sum(total_sales) as sales
from adidas
group by region;

-- 13.Identify the top 5 states by total sales.
SELECT state, SUM(total_sales) AS total_sales
FROM adidas
GROUP BY state
ORDER BY total_sales DESC
LIMIT 5;

-- 14.Calculate average operating margin by category.
SELECT category, AVG(operating_margin) as AVG_margin
FROM adidas
GROUP BY category;

-- 15.Find total operating profit by sales method.
SELECT
sales_method,
sum(operating_profit) AS SUM_profit
FROM adidas
group by sales_method;

-- 16.Show monthly total sales.
SELECT 
    YEAR(invoice_date) AS year,
    MONTH(invoice_date) AS month,
    SUM(total_sales) AS total_sales
FROM adidas
GROUP BY year, month
ORDER BY year, month;

-- 17.Find categories with sales above the overall average.
SELECT category, SUM(total_sales) AS total_sales
FROM adidas
GROUP BY category
HAVING total_sales > (
    SELECT AVG(total_sales) FROM adidas
);

-- 18.Identify the city with the highest sales.
SELECT city, SUM(TOTAL_SALES) AS total_sales
FROM adidas
GROUP BY city
ORDER BY total_sales DESC
LIMIT 1;

-- 19.Find total sales and profit for each retailer.
SELECT retailer,
SUM(TOTAL_SALES) AS SALES,
SUM(OPERATING_PROFIT) AS PROFIT
FROM adidas
GROUP BY retailer
ORDER BY SALES DESC;

-- 20.Calculate profit percentage for each category.
SELECT category,
sum(OPERATING_PROFIT)/sum(TOTAL_SALES)*100 AS profit_percentage
FROM adidas
group by category;

-- 21.Rank regions based on total sales.
SELECT 
region,
SUM(total_sales) AS total_sales,
RANK() OVER ( ORDER BY SUM(total_sales) DESC) AS SALES_RANK
FROM adidas
GROUP BY region
ORDER BY SALES_RANK
LIMIT 5;

-- 22.Find the top-selling product in each region.
SELECT region, product, total_sales
FROM (
    SELECT region, product,
           SUM(total_sales) AS total_sales,
           RANK() OVER (PARTITION BY region ORDER BY SUM(total_sales) DESC) AS rnk
    FROM adidas
    GROUP BY region, product
) t
WHERE rnk = 1;

-- 23.Calculate year-over-year sales growth.
SELECT YEAR(invoice_date) AS year,
       SUM(total_sales) AS total_sales
FROM adidas
GROUP BY year
ORDER BY year;

-- 24.Identify categories contributing more than 30% of total sales.
SELECT category, sum(total_sales) AS total_sales
FROM adidas
GROUP BY category
HAVING total_sales > (
    SELECT sum(total_sales) *0.30 FROM adidas
);

-- 25.Find the retailer with the highest operating margin.
SELECT retailer,
AVG(operating_margin) AS margin
FROM adidas
GROUP BY retailer
ORDER BY margin DESC
LIMIT 1;

-- 26.Detect duplicate invoice records (if any).
SELECT invoice_date, retailer, COUNT(*) AS count
FROM adidas
GROUP BY invoice_date, retailer
HAVING count > 1;

-- 27.Calculate cumulative sales over time.
SELECT invoice_date,
       SUM(total_sales) OVER (ORDER BY invoice_date) AS cumulative_sales
FROM adidas;

-- 28.Compare online vs in-store sales performance.
SELECT sales_method,
       SUM(total_sales) AS total_sales,
       AVG(operating_margin) AS avg_margin
FROM adidas
GROUP BY sales_method;

-- 29.Find states where sales declined month-over-month.
SELECT * FROM ( SELECT state,
        year,
        month,
        total_sales,
        LAG(total_sales) OVER (
            PARTITION BY state 
            ORDER BY year, month
        ) AS prev_sales
    FROM (
        SELECT 
            state,
            YEAR(invoice_date) AS year,
            MONTH(invoice_date) AS month,
            SUM(total_sales) AS total_sales
        FROM adidas
        GROUP BY state, year, month
    ) monthly_sales
) t
WHERE total_sales < prev_sales;

-- 30.Create a view for category-level performance.
CREATE OR REPLACE VIEW category_performance AS
SELECT 
    category,
    SUM(total_sales) AS total_sales,
    SUM(operating_profit) AS total_profit
FROM adidas
GROUP BY category;