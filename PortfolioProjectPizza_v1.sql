/*

PIZZA PROJECT

- Main areas to focus:
	* Orders
	* Stock control
	* Staff

*/

-------------------------------------------------------------------------------------------------------------------------------------

-- Creating the tables 

CREATE TABLE [orders] (
    [row_id] int  NOT NULL ,
    [order_id] varchar(10)  NOT NULL ,
    [created_at] datetime  NOT NULL ,
    [item_id] varchar(10)  NOT NULL ,
    [quantity] int  NOT NULL ,
    [cust_id] int  NOT NULL ,
    [delivery] bit  NOT NULL ,
    [add_id] int  NOT NULL ,
    CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED (
        [row_id] ASC
    )
)

CREATE TABLE [customers] (
    [cust_id] int  NOT NULL ,
    [cust_firstname] varchar(50)  NOT NULL ,
    [cust_lastname] varchar(50)  NOT NULL ,
    CONSTRAINT [PK_custormers] PRIMARY KEY CLUSTERED (
        [cust_id] ASC
    )
)

CREATE TABLE [address] (
    [add_id] int  NOT NULL ,
    [delivery_address1] varchar(250)  NOT NULL ,
    [delivery_address2] varchar(250)  NULL ,
    [delivery_city] varchar(50)  NOT NULL ,
    [delivery_zipcode] varchar(20)  NOT NULL ,
    CONSTRAINT [PK_address] PRIMARY KEY CLUSTERED (
        [add_id] ASC
    )
)


CREATE TABLE [item] (
    [item_id] varchar(10)  NOT NULL ,
    [item_name] varchar(50)  NOT NULL ,
    [item_cat] varchar(50)  NOT NULL ,
    [item_size] varchar(20)  NOT NULL ,
    [item_price] decimal(5,2)  NOT NULL ,
    [sku] varchar(20)  NOT NULL ,
    CONSTRAINT [PK_item] PRIMARY KEY CLUSTERED (
        [item_id] ASC
    )
)

CREATE TABLE [ingredient] (
    [ing_id] varchar(10)  NOT NULL ,
    [ing_name] varchar(250)  NOT NULL ,
    [ing_weight] decimal  NOT NULL ,
    [ing_meas] varchar(20)  NOT NULL ,
    [ing_price] decimal(5,2)  NOT NULL ,
    CONSTRAINT [PK_ingredient] PRIMARY KEY CLUSTERED (
        [ing_id] ASC
    )
)

CREATE TABLE [recipe] (
    [row_id] int  NOT NULL ,
    [recipe_id] varchar(20)  NOT NULL ,
    [ing_id] varchar(10)  NOT NULL ,
    [quantity] int  NOT NULL ,
    CONSTRAINT [PK_recipe] PRIMARY KEY CLUSTERED (
        [row_id] ASC
    )
)

CREATE TABLE [inventory] (
    [inv_id] int  NOT NULL ,
    [item_id] varchar(10)  NOT NULL ,
    [quantity] int  NOT NULL ,
    CONSTRAINT [PK_inventory] PRIMARY KEY CLUSTERED (
        [inv_id] ASC
    )
)

CREATE TABLE [staff] (
    [staff_id] varchar(20)  NOT NULL ,
    [first_name] varchar(50)  NOT NULL ,
    [last_name] varchar(50)  NOT NULL ,
    [position] varchar(100)  NOT NULL ,
    [hourly_rate] decimal(5,2)  NOT NULL ,
    CONSTRAINT [PK_staff] PRIMARY KEY CLUSTERED (
        [staff_id] ASC
    )
)

CREATE TABLE [shift] (
    [shift_id] varchar(20)  NOT NULL ,
    [day_of_week] varchar(20)  NOT NULL ,
    [start_time] time  NOT NULL ,
    [end_time] time  NOT NULL ,
    CONSTRAINT [PK_shift] PRIMARY KEY CLUSTERED (
        [shift_id] ASC
    )
)


CREATE TABLE [rota] (
    [row_id] int  NOT NULL ,
    [rota_id] varchar(20)  NOT NULL ,
    [date] date  NOT NULL ,
    [shift_id] varchar(20)  NOT NULL ,
    [staff_id] varchar(20)  NOT NULL ,
    CONSTRAINT [PK_rota] PRIMARY KEY CLUSTERED (
        [row_id] ASC
    )
)

-------------------------------------------------------------------------------------------------------------------------------------

-- Populating the tables

BULK INSERT address
FROM '...\Data\address.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);

BULK INSERT customers
FROM '...\Data\customer.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);

BULK INSERT ingredient
FROM '...\Data\ingredients.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);

BULK INSERT item
FROM '...\Data\items.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);


BULK INSERT recipe
FROM '...\Data\recipe.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);

BULK INSERT rota
FROM '...\Data\rotas.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);

BULK INSERT shift
FROM '...\Data\shift.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);

BULK INSERT orders
FROM '...\Data\orders.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);

BULK INSERT staff
FROM '...\Data\staff.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);

BULK INSERT inventory
FROM '...\Data\inv.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = ';',
	ROWTERMINATOR = '\n'
);

-------------------------------------------------------------------------------------------------------------------------------------

-- Creating a view with the necessary columns to develop dash1

CREATE VIEW dash1 
AS
SELECT o.row_id, o.order_id, o.created_at, o.item_id, o.quantity, o.cust_id, o.delivery, o.add_id
, i.item_name, i.item_cat, i.item_price 
, a.delivery_address1, a.delivery_address2
, c.cust_firstname, c.cust_lastname
FROM PortfolioProjectRestaurant.dbo.orders o
JOIN PortfolioProjectRestaurant.dbo.item i
	ON o.item_id = i.item_id
JOIN PortfolioProjectRestaurant.dbo.address a
	ON o.add_id = a.add_id
JOIN PortfolioProjectRestaurant.dbo.customers c
	ON o.cust_id = c.cust_id

-- Total orders

SELECT COUNT(DISTINCT(order_id)) AS Total_orders
FROM dash1

-- Total sales

SELECT COUNT(order_id) AS Total_sales, SUM(item_price) AS Profit
FROM dash1

-- Total items

SELECT COUNT(item_id) AS Total_items
FROM dash1

-- Average order value

SELECT AVG(item_price) AS Avg_order_value
FROM dash1

-- Sales by category

SELECT item_cat, SUM(quantity) AS Total_sales
FROM dash1
GROUP BY item_cat

-- Top selling items

SELECT TOP 5 item_name, SUM(quantity) AS Total_sales
FROM dash1
GROUP BY item_name
ORDER BY Total_sales DESC

-- Top selling pizzas

SELECT TOP 5 item_name, SUM(quantity) AS Total_sales
FROM dash1
WHERE item_cat = 'PIZZA'
GROUP BY item_name
ORDER BY Total_sales DESC

-- Orders by hour

SELECT CAST(created_at as date) AS ForDate,
       DATEPART(hour, created_at) AS OnHour,
       COUNT(DISTINCT(order_id)) AS Totals
FROM dash1
GROUP BY CAST(created_at as date),
       DATEPART(hour,created_at)
ORDER BY CAST(created_at as date)

-- Sales by hour

SELECT CAST(created_at as date) AS ForDate,
       DATEPART(hour, created_at) AS OnHour,
       COUNT(order_id) AS Totals
FROM dash1
GROUP BY CAST(created_at as date),
       DATEPART(hour,created_at)
ORDER BY CAST(created_at as date)

-- Order by customers

SELECT cust_id, COUNT(DISTINCT(order_id)) AS Total
FROM dash1
GROUP BY cust_id

-- Top 5 customers

SELECT TOP 5 cust_id, COUNT(DISTINCT(order_id)) AS Total
FROM dash1
GROUP BY cust_id 
ORDER BY Total DESC

-- Order by delivery

SELECT delivery, COUNT(delivery) AS Total
FROM dash1
GROUP BY delivery

-------------------------------------------------------------------------------------------------------------------------------------

-- Creating a view with the necessary columns to develop stock1

CREATE VIEW stock1
AS
SELECT s1.item_name
, s1.ing_id
, s1.ing_name
, s1.ing_weight
, s1.ing_price
, s1.order_quantity
, s1.recipe_quantity
, s1.order_quantity * s1.recipe_quantity AS ordered_weight
, s1.ing_price/s1.ing_weight AS unit_cost
, (s1.order_quantity*s1.recipe_quantity)*(s1.ing_price/s1.ing_weight) AS ingredient_cost
FROM (
SELECT o.item_id
, i.sku
, i.item_name
, r.ing_id
, ing.ing_name
, r.quantity as recipe_quantity
, SUM(o.quantity) as order_quantity
, ing.ing_weight
, ing_price
FROM PortfolioProjectRestaurant.dbo.orders o
LEFT JOIN PortfolioProjectRestaurant.dbo.item i
	ON o.item_id = i.item_id
LEFT JOIN PortfolioProjectRestaurant.dbo.recipe r
	ON i.sku = r.recipe_id
LEFT JOIN PortfolioProjectRestaurant.dbo.ingredient ing
	ON r.ing_id = ing.ing_id
GROUP BY o.item_id
, i.sku
, i.item_name
, r.ing_id
, r.quantity
, ing.ing_name
, ing.ing_weight
, ing_price
) s1

SELECT s2.ing_name
, s2.ordered_weight
, ing.ing_weight
, inv.quantity
, ing.ing_weight*inv.quantity AS total_inv_weight
, (ing.ing_weight*inv.quantity) - s2.ordered_weight AS remaining_weight 
FROM (
SELECT ing_name
, ing_id
, SUM(ordered_weight) AS ordered_weight
FROM stock1
GROUP BY ing_name, ing_id
) s2
LEFT JOIN PortfolioProjectRestaurant.dbo.inventory inv
	ON inv.item_id = s2.ing_id
LEFT JOIN	PortfolioProjectRestaurant.dbo.ingredient ing
	ON ing.ing_id = s2.ing_id

-------------------------------------------------------------------------------------------------------------------------------------

-- Creating a view with the necessary columns to develop dash3

CREATE VIEW dash3
AS
SELECT r.date
, st.first_name, st.last_name, st.hourly_rate
, sh.start_time, sh.end_time
, DATEDIFF(MINUTE, sh.start_time, sh.end_time)/60 AS work_hours
, st.hourly_rate * DATEDIFF(MINUTE, sh.start_time, sh.end_time)/60 AS staff_cost_route
FROM PortfolioProjectRestaurant.dbo.rota r
LEFT JOIN PortfolioProjectRestaurant.dbo.staff st
	ON r.staff_id = st.staff_id
LEFT JOIN PortfolioProjectRestaurant.dbo.shift sh
	ON r.shift_id = sh.shift_id


