-- Check CSV data has imported correctly and perform data validation for baked_good

PRAGMA table_info (baked_good);

SELECT *
FROM baked_good
LIMIT 10;


-- Check CSV data has imported correctly and perform data validation for customer

PRAGMA table_info (customer);

SELECT *
FROM customer
LIMIT 10;


-- Check CSV data has imported correctly and perform data validation for ingredient

PRAGMA table_info (ingredient);

SELECT *
FROM ingredient
LIMIT 10;


-- Check CSV data has imported correctly and perform data validation for orders

PRAGMA table_info (orders);

SELECT *
FROM orders
LIMIT 10;


-- Check CSV data has imported correctly and perform data validation for recipe

PRAGMA table_info (recipe);

SELECT *
FROM recipe
LIMIT 10;


-- Query to find total revenue for each day of the week

SELECT
    CASE STRFTIME('%w', DATE(OrderDate))
        WHEN '0' THEN 'Sunday'
        WHEN '1' THEN 'Monday'
        WHEN '2' THEN 'Tuesday'
        WHEN '3' THEN 'Wednesday'
        WHEN '4' THEN 'Thursday'
        WHEN '5' THEN 'Friday'
        WHEN '6' THEN 'Saturday'
    END AS DayOfWeek,
    SUM(TotalOrderPrice) AS Revenue
FROM orders
GROUP BY STRFTIME('%w', DATE(OrderDate))
ORDER BY STRFTIME('%w', DATE(OrderDate));


-- Query to find top 10 best-selling baked goods using the highest quantity sold

SELECT 
    bg.Name AS BakedGood,
    SUM(o.Quantity) AS TotalUnitsSold,
    SUM(o.TotalOrderPrice) AS TotalRevenue
FROM orders o
JOIN baked_good bg ON o.BakedGoodID = bg.BakedGoodID
GROUP BY bg.Name
ORDER BY TotalUnitsSold DESC
LIMIT 10;


-- Query to calculate average spend per order

SELECT 
    AVG(TotalOrderPrice) AS AverageOrderValue
FROM orders;


-- Query to generate data used in visualisation of percentage of return customers

SELECT 
    CASE 
        WHEN COUNT(o.OrderID) = 1 THEN 'One-Time'
        ELSE 'Repeat'
    END AS CustomerType,
    COUNT(DISTINCT o.CustomerID) AS CustomerCount
FROM orders o
GROUP BY o.CustomerID;


-- Query to find baked goods' prep time vs how many units are sold

SELECT 
    bg.Name,
    bg.PrepTimeMins,
    SUM(o.Quantity) AS UnitsSold
FROM orders o
JOIN baked_good bg ON o.BakedGoodID = bg.BakedGoodID
GROUP BY bg.Name, bg.PrepTimeMins
ORDER BY UnitsSold DESC;

--Query to find the ingredient that is being used the most

SELECT 
    i.Name AS Ingredient,
    SUM(r.Quantity * o.Quantity) AS TotalUsed
FROM orders o
JOIN recipe r ON o.BakedGoodID = r.BakedGoodID
JOIN ingredient i ON r.IngredientID = i.IngredientID
GROUP BY i.Name
ORDER BY TotalUsed DESC;