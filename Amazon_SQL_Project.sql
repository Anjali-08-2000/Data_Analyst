# Data Wrangling

   # Data Base Creation

CREATE DATABASE AMAZON_SALE;
USE AMAZON_SALE

# Table Formation
CREATE TABLE sales (
    invoice_id VARCHAR(30) NOT NULL,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    vat FLOAT NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_percentage FLOAT NOT NULL,
    gross_income DECIMAL(10, 2) NOT NULL,
    rating FLOAT NOT NULL
);

# Inserted Amazon.csv file in tables as sales

select * from sales;

# Checking null values

select count(*) as count_of_null_values from sales
where null;

# To check datatypes

desc sales

# Feature Engineering
alter table sales
add time_of_day varchar(15) not null;

select * from sales.

UPDATE sales
SET time_of_day =
    CASE
        WHEN HOUR(time) >= 5 AND HOUR(time) < 12 THEN 'Morning'
        WHEN HOUR(time) >= 12 AND HOUR(time) < 17 THEN 'Afternoon'
        ELSE 'Evening'
    END
WHERE time IS NOT NULL;

select * from sales;

## Feature Engineering - Add a new column named dayname that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). 

ALTER TABLE sales
add COLUMN day_week varchar(10);

select * from sales;

update sales
set day_week = dayname (date) ;

select * from sales;

#Feature Engineering - Add a new column named monthname that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar)

ALTER TABLE sales
ADD COLUMN month_name VARCHAR(10);

update sales
set month_name = monthname (date) ;

select * from sales

# Exploratory Data Analysis 

## Business Questions To Answer:

# 1) What is the count of distinct cities in the dataset?
SELECT COUNT(DISTINCT city) AS distinct_cities_count FROM sales;
 
# 2) For each branch, what is the corresponding city?
SELECT branch, city FROM sales GROUP BY branch, city;

# 3) What is the count of distinct product lines in the dataset?
SELECT COUNT(DISTINCT product_line) AS distinct_product_lines_count FROM sales;

# 4) Which payment method occurs most frequently?
SELECT payment_method, COUNT(*) AS payment_count
FROM sales
GROUP BY payment_method
ORDER BY payment_count DESC
LIMIT 1;

# 5) Which product line has the highest sales?
SELECT product_line, SUM(total) AS total_sales
FROM sales
GROUP BY product_line
ORDER BY total_sales DESC
LIMIT 1;


# 6) How much revenue is generated each month?
SELECT month_name, SUM(total) AS monthly_revenue
FROM sales
GROUP BY month_name
ORDER BY MONTH(STR_TO_DATE(month_name, '%M'));


# 7) In which month did the cost of goods sold reach its peak?
select month_name, sum(cogs) as cost_of_goods_sold from sales
group by month_name
order by cost_of_goods_sold desc;

# 8) Which product line generated the highest revenue?
SELECT product_line, SUM(total) AS total_revenue 
FROM sales 
GROUP BY product_line 
ORDER BY total_revenue DESC 
LIMIT 1;


# 9) In which city was the highest revenue recorded?
SELECT city, SUM(total) AS total_revenue 
FROM sales 
GROUP BY city 
ORDER BY total_revenue DESC 
LIMIT 1;


# 10) Which product line incurred the highest Value Added Tax?
SELECT product_line, SUM(VAT) AS total_VAT 
FROM sales 
GROUP BY product_line 
ORDER BY total_VAT DESC 
LIMIT 1;


# 11) For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
SELECT product_line, 
       SUM(total) AS total_sales,
       CASE 
           WHEN SUM(total) > (SELECT AVG(total) FROM sales) THEN 'Good' 
           ELSE 'Bad' 
       END AS sales_performance
FROM sales 
GROUP BY product_line;


# 12) Identify the branch that exceeded the average number of products sold.
SELECT branch, SUM(quantity) AS total_quantity 
FROM sales 
GROUP BY branch 
HAVING total_quantity > (SELECT AVG(quantity) FROM sales);


# 13) Which product line is most frequently associated with each gender?
SELECT gender, product_line, COUNT(*) AS occurrences 
FROM sales 
GROUP BY gender, product_line 
ORDER BY gender, occurrences DESC;


# 14) Calculate the average rating for each product line.
SELECT product_line, AVG(rating) AS avg_rating 
FROM sales 
GROUP BY product_line 
ORDER BY avg_rating DESC;


# 15) Count the sales occurrences for each time of day on every weekday.
select day_week, time_of_day, count(*) sales from sales 
group by day_week, time_of_day
order by field(day_week, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'), 
field(time_of_day, 'Morning', 'Afternoon', 'Evening');

select * from sales

# 16) Identify the customer type contributing the highest revenue.
SELECT customer_type, SUM(total) AS total_revenue 
FROM sales 
GROUP BY customer_type 
ORDER BY total_revenue DESC 
LIMIT 1;


# 17) Determine the city with the highest VAT percentage.
SELECT city, AVG(VAT/total * 100) AS avg_VAT_percentage 
FROM sales 
GROUP BY city 
ORDER BY avg_VAT_percentage DESC 
LIMIT 1;


# 18) Identify the customer type with the highest VAT payments.
SELECT customer_type, SUM(VAT) AS total_VAT 
FROM sales 
GROUP BY customer_type 
ORDER BY total_VAT DESC 
LIMIT 1;


# 19) What is the count of distinct customer types in the dataset?
SELECT COUNT(DISTINCT customer_type) AS distinct_customer_types FROM sales;


# 20) What is the count of distinct payment methods in the dataset?
SELECT COUNT(DISTINCT payment_method) AS distinct_payment_methods FROM sales;


# 21) Which customer type occurs most frequently?
SELECT customer_type, COUNT(*) AS occurrences 
FROM sales 
GROUP BY customer_type 
ORDER BY occurrences DESC 
LIMIT 1;


# 22) Identify the customer type with the highest purchase frequency.
SELECT customer_type, COUNT(invoice_id) AS purchase_count 
FROM sales 
GROUP BY customer_type 
ORDER BY purchase_count DESC 
LIMIT 1;


# 23) Determine the predominant gender among customers.
SELECT gender, COUNT(*) AS gender_count 
FROM sales 
GROUP BY gender 
ORDER BY gender_count DESC 
LIMIT 1;


# 24) Examine the distribution of genders within each branch.
SELECT branch, gender, COUNT(*) AS gender_count 
FROM sales 
GROUP BY branch, gender 
ORDER BY branch, gender_count DESC;


# 25) Identify the time of day when customers provide the most ratings.
SELECT time_of_day, COUNT(rating) AS rating_count 
FROM sales 
GROUP BY time_of_day 
ORDER BY rating_count DESC 
LIMIT 1;


# 26) Determine the time of day with the highest customer ratings for each branch.
SELECT branch, time_of_day, AVG(rating) AS avg_rating 
FROM sales 
GROUP BY branch, time_of_day 
ORDER BY branch, avg_rating DESC;


# 27) Identify the day of the week with the highest average ratings.
SELECT day_week, AVG(rating) AS avg_rating 
FROM sales 
GROUP BY day_week 
ORDER BY avg_rating DESC 
LIMIT 1;


# 28) Determine the day of the week with the highest average ratings for each branch.
SELECT branch, day_week, AVG(rating) AS avg_rating 
FROM sales 
GROUP BY branch, day_week
ORDER BY branch, avg_rating DESC;


