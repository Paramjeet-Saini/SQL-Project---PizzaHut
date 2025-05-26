CREATE DATABASE PizzaHut;
USE PizzaHut;


							
					-- creating different tables for different data.

CREATE TABLE Pizzas(
Pizza_ID VARCHAR(20) PRIMARY KEY,
Pizza_Type_ID VARCHAR(20),
Size VARCHAR(1),
Price NUMERIC (6,2) NOT NULL
);
				   -- now importing pizza data through Data Import Wizard.alter   

SELECT * FROM Pizzas;


/*
  now i will do the same for remaining 3 tables.
  - creating a table
  - importing data into it
  - then solving related questions
  */

CREATE TABLE Pizza_Types(
Pizza_Type_ID VARCHAR(50) PRIMARY KEY,
Name VARCHAR(50),
Category VARCHAR(20),
Ingredients VARCHAR (200) 
);   

SELECT * FROM Pizza_Types;



CREATE TABLE Orders(
Order_ID INT NOT NULL PRIMARY KEY,
Order_Date DATE NOT NULL,
Order_Time TIME NOT NULL
); 

SELECT * FROM Orders;



CREATE TABLE Order_Details(
Order_Detail_ID INT NOT NULL PRIMARY KEY,
Order_ID INT NOT NULL,
Pizza_ID VARCHAR(100),
Quantity INT NOT NULL
);



