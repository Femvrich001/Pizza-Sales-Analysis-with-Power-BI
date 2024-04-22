-- Retrieve all data from the pizza_sales table
SELECT * FROM pizza_sales;

-- Total Revenue:
SELECT ROUND(SUM(total_price), 2) AS Total_Revenue FROM pizza_sales;

-- Average order values
SELECT ROUND((SUM(total_price) / COUNT(DISTINCT order_id)), 2) AS Avg_order_Value FROM pizza_sales;

-- Total number of pizzas sold
SELECT SUM(quantity) AS Total_pizzas_sold FROM pizza_sales;

-- Total number of orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales;

-- The average number of pizzas per order
SELECT 
    ROUND(
        SUM(quantity) / COUNT(DISTINCT order_id), -- Calculate the total pizzas sold divided by the number of distinct orders
        2  -- Round the result to two decimal places
    ) AS Avg_Pizzas_per_order
FROM 
    pizza_sales;

-- The daily trend for total orders
SELECT 
    order_day,
    total_orders
FROM (
    SELECT 
        DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_day,
        COUNT(DISTINCT order_id) AS total_orders
    FROM 
        pizza_sales
    GROUP BY 
        DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y'))
) AS subquery
ORDER BY
    FIELD(order_day, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- The monthly trend for orders
SELECT 
    Month_Name,
    Total_Orders
FROM (
    SELECT 
        MONTHNAME(STR_TO_DATE(order_date, '%d-%m-%Y')) AS Month_Name,
        COUNT(DISTINCT order_id) AS Total_Orders
    FROM 
        pizza_sales
    GROUP BY 
        MONTHNAME(STR_TO_DATE(order_date, '%d-%m-%Y'))
) AS subquery
ORDER BY 
    MONTH(STR_TO_DATE(CONCAT('01-', Month_Name, '-2022'), '%d-%M-%Y'));

-- The percentage of sales by pizza category
SELECT 
    pizza_category,
    ROUND(SUM(total_price), 2) AS total_revenue, -- Ensure total revenue is rounded to 2 decimal places
    ROUND(SUM(total_price) * 100 / total_sales.total_revenue, 2) AS PCT
FROM 
    pizza_sales
CROSS JOIN (
    SELECT ROUND(SUM(total_price), 2) AS total_revenue FROM pizza_sales -- Calculate and round the total revenue across all pizza categories
) AS total_sales
GROUP BY 
    pizza_category, total_sales.total_revenue;

-- The percentage of sales by pizza size
SELECT 
    pizza_size,
    ROUND(SUM(total_price), 2) AS total_revenue, -- Rounding the result to 2 decimal places
    ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales), 2) AS PCT
FROM 
    pizza_sales
GROUP BY 
    pizza_size;

-- Check if there are any sales records for February
SELECT DISTINCT MONTH(order_date) AS month_number
FROM pizza_sales;

-- Check if there are any sales records for February
SELECT DISTINCT STR_TO_DATE(order_date, '%d-%m-%Y') AS order_date_formatted
FROM pizza_sales
WHERE MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) = 2;

-- Total Pizzas Sold by Pizza Category for February
SELECT 
    pizza_category, 
    SUM(quantity) as Total_Quantity_Sold
FROM 
    pizza_sales
WHERE 
    MONTH(STR_TO_DATE(order_date, '%d-%m-%Y')) = 2
GROUP BY 
    pizza_category
ORDER BY 
    Total_Quantity_Sold DESC;

-- Retrieve the top 5 pizzas by revenue
SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
LIMIT 5;

-- Retrieve the bottom 5 pizzas by revenue
SELECT pizza_name, 
ROUND(SUM(total_price), 2) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC
LIMIT 5;

-- Retrieve the top 5 pizzas by quantity sold
SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold DESC
LIMIT 5;

-- Retrieve the bottom 5 pizzas by quantity sold
SELECT pizza_name, SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza_Sold ASC
LIMIT 5;

-- Retrieve the top 5 pizzas by total orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC
LIMIT 5;

-- Retrieve the bottom 5 pizzas by total orders
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders ASC
LIMIT 5;

-- Retrieve the bottom 5 pizzas by total orders for the 'Classic' category
SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
WHERE pizza_category = 'Classic'
GROUP BY pizza_name
ORDER BY Total_Orders ASC
LIMIT 5;











