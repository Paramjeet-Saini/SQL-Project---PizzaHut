
-- ANSWERS (select and run answer to show corresponding question's answer).

SELECT * FROM ANSWER1;					SELECT * FROM ANSWER2;					SELECT * FROM ANSWER3;
SELECT * FROM ANSWER4;					SELECT * FROM ANSWER5;					SELECT * FROM ANSWER6;
SELECT * FROM ANSWER7;					SELECT * FROM ANSWER8;					SELECT * FROM ANSWER9;
SELECT * FROM ANSWER10;					SELECT * FROM ANSWER11;					SELECT * FROM ANSWER12;
SELECT * FROM ANSWER13;

-- --------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------
-- ------------ QUESTIONS ---------------------------------------------------------------------------------

-- 1) Retrieve the total number of orders placed.

CREATE VIEW ANSWER1 AS
    SELECT 
        COUNT(Order_ID) AS TOTAL_ORDERS
    FROM
        Orders;

      -- ANSWER = 21350 Total Orders.
      
-- ----------------------------------------------------------------


-- 2) Calculate the total revenue generated from pizza sales.

CREATE VIEW ANSWER2 AS
    SELECT 
        SUM(Order_Details.Quantity * Pizzas.Price) AS TOTAL_REVENUE
    FROM
        Order_Details
            INNER JOIN
        Pizzas ON Order_Details.Pizza_ID = Pizzas.Pizza_ID;
   
   -- ANSWER = 802777.45    
 

-- -----------------------------------------------------------------


-- 3) Identify the highest-priced pizza.

CREATE VIEW ANSWER3 AS
    SELECT 
        Pizza_Types.Name, Pizzas.Price
    FROM
        Pizza_Types
            INNER JOIN
        Pizzas ON Pizza_Types.Pizza_Type_ID = Pizzas.Pizza_Type_ID
    ORDER BY Pizzas.Price DESC
    LIMIT 1;

		-- OR --
        
SELECT Pizza_Type_ID, Price FROM Pizzas
ORDER BY Price DESC
LIMIT 1; 		-- since Pizzas(Pizza_Type_ID) already had names so inner join could be avoided. 


  -- Answer = The Brie Carre Pizza  at Rs 23.65


-- -----------------------------------------------------------------


-- 4) Identify the most common pizza size ordered.

/*
SELECT Order_Details.Quantity, Pizzas.Size
FROM Order_Details INNER JOIN Pizzas
ON Order_Details.Pizza_ID = Pizzas.Pizza_ID;
		
        (i will use this as a sub-querry)
*/

CREATE VIEW ANSWER4 AS
    SELECT 
        Size, COUNT(Quantity)
    FROM
        (SELECT 
            Order_Details.Quantity, Pizzas.Size
        FROM
            Order_Details
        INNER JOIN Pizzas ON Order_Details.Pizza_ID = Pizzas.Pizza_ID) AS PIZZA
    GROUP BY Size
    ORDER BY COUNT(Quantity) DESC;

  --  OR --

SELECT 
    Pizzas.Size, COUNT(Order_Details.Quantity) AS Order_Count
FROM
    Pizzas
        INNER JOIN
    Order_Details ON Pizzas.Pizza_ID = order_details.Pizza_ID
GROUP BY Pizzas.Size
ORDER BY COUNT(Order_Details.Quantity) DESC;

		-- Answer = 'L'  total_orders='18526'

        
-- -----------------------------------------------------------------        


-- 5) List the top 5 most ordered pizza types along with their quantities


CREATE VIEW ANSWER5 AS
    SELECT 
        pizza_types.Name, SUM(order_details.Quantity) AS TOTAL_SUM
    FROM
        pizza_types
            INNER JOIN
        pizzas ON pizza_types.Pizza_Type_ID = pizzas.Pizza_Type_ID
            INNER JOIN
        order_details ON order_details.Pizza_ID = pizzas.Pizza_ID
    GROUP BY pizza_types.Name
    ORDER BY COUNT(order_details.Quantity) DESC
    LIMIT 5;

 -- Answer =
 
/* # 		Name	                       TOTAL_COUNT
		
			The Classic Deluxe Pizza			2453
			The Barbecue Chicken Pizza			2432
			The Hawaiian Pizza					2422
			The Pepperoni Pizza					2418
			The Thai Chicken Pizza				2371

*/ 

-- ----------------------------------------------------------------- 


						-- Intermediate Questions --
                        

-- 6) Join the necessary tables to find the total quantity of each pizza category ordered.

CREATE VIEW ANSWER6 AS
    SELECT 
        Pizza_Types.Category,
        SUM(Order_Details.Quantity) AS Total_Quantity
    FROM
        Pizza_Types
            INNER JOIN
        pizzas ON Pizza_Types.Pizza_Type_ID = pizzas.Pizza_Type_ID
            INNER JOIN
        Order_Details ON Order_Details.Pizza_ID = pizzas.Pizza_ID
    GROUP BY Pizza_Types.Category
    ORDER BY SUM(Order_Details.Quantity) DESC;
 

/*  Answer = 
       Category	         Total_Quantity
       
		Classic				14308
		Supreme				11987
		Veggie				11649
		Chicken				11050
*/

-- -----------------------------------------------------------------


-- 7) Determine the distribution of orders by hour of the day.


CREATE VIEW ANSWER7 AS
    SELECT 
        HOUR(Order_Time) AS Hour, COUNT(Order_ID) AS Order_Count
    FROM
        Orders
    GROUP BY HOUR(Order_Time);

SELECT * FROM ANSWER7;  -- USE THIS TO VIEW ANSWER.


-- -----------------------------------------------------------------


-- 8) Join relevant tables to find the category-wise distribution of pizzas.

CREATE VIEW ANSWER8 AS
    SELECT 
        Category, COUNT(Name) AS Total_Pizzas
    FROM
        Pizza_Types
    GROUP BY Category
    ORDER BY COUNT(Name) DESC;


-- -----------------------------------------------------------------


-- 9) Group the orders by date and calculate the average number of pizzas ordered per day.

/*
SELECT Orders.Order_Date, SUM(Order_Details.Quantity) AS Total_Orders
FROM Orders INNER JOIN Order_Details
ON Orders.Order_ID = Order_Details.Order_ID
GROUP BY Orders.Order_Date;
*/  -- MAKING THIS A SUB-QUERY

CREATE VIEW ANSWER9 AS
    SELECT 
        ROUND(AVG(Total_Orders), 0) AS Pizza_Ordered_PerDay
    FROM
        (SELECT 
            Orders.Order_Date,
                SUM(Order_Details.Quantity) AS Total_Orders
        FROM
            Orders
        INNER JOIN Order_Details ON Orders.Order_ID = Order_Details.Order_ID
        GROUP BY Orders.Order_Date) AS TEMP;


-- -----------------------------------------------------------------


-- 10) Determine the top 3 most ordered pizza types based on revenue.

CREATE VIEW ANSWER10 AS
    SELECT 
        Pizza_Types.Name,
        SUM(Order_Details.Quantity * Pizzas.Price) AS Total_Revenue
    FROM
        Pizza_Types
            INNER JOIN
        Pizzas ON Pizza_Types.Pizza_Type_ID = Pizzas.Pizza_Type_ID
            INNER JOIN
        Order_Details ON Order_Details.Pizza_ID = Pizzas.Pizza_ID
    GROUP BY Pizza_Types.Name
    ORDER BY SUM(Order_Details.Quantity * Pizzas.Price) DESC
    LIMIT 3;

/*   Answer = 
		 Name						Total_Revenue
The Thai Chicken Pizza				43434.25
The Barbecue Chicken Pizza			42768.00
The California Chicken Pizza		41409.50

*/

-- -----------------------------------------------------------------


-- 11) Calculate the percentage contribution of each pizza type to total revenue.

CREATE VIEW ANSWER11 AS
SELECT 
    Pizza_Types.Category,
    ROUND(SUM(Order_Details.Quantity * Pizzas.Price) / (SELECT 
                    SUM(Order_Details.Quantity * Pizzas.Price) AS TOTAL_REVENUE
                FROM
                    Order_Details
                        INNER JOIN
                    Pizzas ON Order_Details.Pizza_ID = Pizzas.Pizza_ID) * 100,
            2) AS Percent_Contribution
FROM
    Pizza_Types
        INNER JOIN
    Pizzas ON Pizza_Types.Pizza_Type_ID = Pizzas.Pizza_Type_ID
        INNER JOIN
    Order_Details ON Order_Details.Pizza_ID = Pizzas.Pizza_ID
GROUP BY Pizza_Types.Category;


-- -----------------------------------------------------------------

 
-- 12) Analyze the cumulative revenue generated over time.

/*
SELECT Orders.Order_Date,
SUM(Order_Details.Quantity * Pizzas.Price) AS Revenue
FROM Orders INNER JOIN Order_Details
ON Orders.Order_ID = Order_Details.Order_ID 
INNER JOIN Pizzas
ON Pizzas.Pizza_ID = Order_Details.Pizza_ID
GROUP BY Orders.Order_Date;
*/  
-- CREATING THIS AS A SUB-QUERY

CREATE VIEW ANSWER12 AS
SELECT Order_Date,
SUM(Revenue) OVER(ORDER BY Order_Date) AS Cumu_Revenue
FROM 
(SELECT Orders.Order_Date,
SUM(Order_Details.Quantity * Pizzas.Price) AS Revenue
FROM Orders INNER JOIN Order_Details
ON Orders.Order_ID = Order_Details.Order_ID 
INNER JOIN Pizzas
ON Pizzas.Pizza_ID = Order_Details.Pizza_ID
GROUP BY Orders.Order_Date
) AS TEMP;


-- -----------------------------------------------------------------


-- 13) Determine the top 3 most ordered pizza types based on revenue for each pizza category.

/*
SELECT Pizza_Types.Category,
Pizza_Types.Name, 
SUM(Order_Details.Quantity*Pizzas.Price) AS Revenue
FROM Pizza_Types INNER JOIN Pizzas
ON Pizza_Types.Pizza_Type_ID = Pizzas.Pizza_Type_ID
INNER JOIN Order_Details 
ON Order_Details.Pizza_ID = Pizzas.Pizza_ID
GROUP BY Pizza_Types.Category,Pizza_Types.Name;
																CREATED A SUB=QUERY TO EXECUTE RANK COMMAND
														

SELECT 
Category, Name, Revenue,
RANK() OVER(PARTITION BY Category ORDER BY Revenue DESC) AS RN
FROM (
SELECT Pizza_Types.Category,
Pizza_Types.Name, 
SUM(Order_Details.Quantity*Pizzas.Price) AS Revenue
FROM Pizza_Types INNER JOIN Pizzas
ON Pizza_Types.Pizza_Type_ID = Pizzas.Pizza_Type_ID
INNER JOIN Order_Details 
ON Order_Details.Pizza_ID = Pizzas.Pizza_ID
GROUP BY Pizza_Types.Category,Pizza_Types.Name
) AS TABLE_A;
														MADE THIS INTO ANOTHER SUB-QUERY SO THAT WE CAN USE CONDITION
														"WHERE RN <= 3 " SINCE WE CANNOT USE RANK WITH WHERE.
*/

CREATE VIEW ANSWER13 AS
SELECT 
Category, Name, Revenue, RN
FROM(
SELECT 
Category, Name, Revenue,
RANK() OVER(PARTITION BY Category ORDER BY Revenue DESC) AS RN
FROM (
SELECT Pizza_Types.Category,
Pizza_Types.Name, 
SUM(Order_Details.Quantity*Pizzas.Price) AS Revenue
FROM Pizza_Types INNER JOIN Pizzas
ON Pizza_Types.Pizza_Type_ID = Pizzas.Pizza_Type_ID
INNER JOIN Order_Details 
ON Order_Details.Pizza_ID = Pizzas.Pizza_ID
GROUP BY Pizza_Types.Category,Pizza_Types.Name
) AS TABLE_A) AS TABLE_B
WHERE RN <= 3;



-- -------------------------------END----------------------------------


