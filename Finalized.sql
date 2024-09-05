select * from pizza_sales      /*Everything from tale*/

select SUM(total_price) as Total_Revenue  from pizza_sales       /* Total Revenue: with column name */

select count(order_id) from pizza_sales  /*Including repition of same order_id*/

select count(distinct(order_id)) from pizza_sales 

select sum(total_price)/count(distinct order_id) as Average_Order_Value from pizza_sales   /*Average Order Value*/

select sum(quantity) as Total_Pizzas_Sold from pizza_sales  /*Total Pizzas Sold*/

select  count(distinct(order_id)) as Total_Orders from pizza_sales  /*Total Orders*/

select  count(distinct order_id) as Total_Orders from pizza_sales  /*Total Orders*/

select sum(quantity)/ count(distinct order_id) as Average_Pizzas_Per_Order from pizza_sales /*Average_Pizzas_Per_Order*/

/*Io convert Average_Pizzas_Per_Order to decimal*/
select cast (sum(quantity) as decimal(10,2))/cast(count(distinct order_id) as decimal(10,2)) as Average_Pizza_Per_Order from pizza_sales 
/*meaning of this[decimal(10,2)] is We can get 10 decimal point and out 0f 10 it will give 2 decimal point*/

select cast (sum(quantity) /count(distinct order_id) as decimal(10,2)) as Average_Pizza_Per_Order from pizza_sales /*two decimal points given as result ut they are only zeros*/

select cast(cast (sum(quantity) as decimal(10,2))/cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2)) as Average_Pizza_Per_Order from pizza_sales 
/*This will give the correct real value of two decimal points out of 10 decimal points*/

/*daily trend chart*/
select DATENAME(DW , order_date) as order_day , count(distinct order_id) as Total_Orders
from pizza_sales
group by(order_date) /*This will seperately give total orders of a particular weekday */

/*daily trend chart*/
select DATENAME(DW , order_date) as order_day , count(distinct order_id) as Total_Orders
from pizza_sales
group by DATENAME(DW , order_date) -- DW (Day of the Week)

-- Hourly  Trend
select DATEPART(HOUR, order_time ) as Order_Hours , count(distinct order_id) as Total_Orders
from pizza_sales
group by(DATEPART(HOUR, order_time ))
order by(DATEPART(HOUR, order_time ))

-- Percentage of total sales with respect to pizza category
select pizza_category , sum(total_price) *100 / (select sum(total_price) from pizza_sales ) 
AS Total_Percentage_Sales from pizza_sales
Group By(pizza_category)

select pizza_category ,sum(total_price) as Total_Sales_for_Categories , sum(total_price) *100 / (select sum(total_price) from pizza_sales ) 
AS Total_Percentage_Sales from pizza_sales                   -- sum(total_price) as Total_Sales_for_Categories this will give the some Total sales price for different categories
Group By(pizza_category)

-- If we want to calclate this only for particular month we can use WHERE function
-- if we use subquery we need to apply filters or any other things which is applied for main querry also . Here that is why we didn't get percentage with respect to a particular month

select pizza_category ,sum(total_price) as Total_Sales_for_Categories , sum(total_price) *100 / (select sum(total_price) from pizza_sales ) 
AS Total_Percentage_Sales from pizza_sales -- sum(total_price) as Total_Sales_for_Categories this will give the some Total sales price for different categories
WHERE MONTH(order_date) = 1
Group By(pizza_category)

-- since where function is applied to subquery also we get the correct percentage with respect to the January month

select pizza_category ,sum(total_price) as Total_Sales_for_Categories , sum(total_price) *100 / (select sum(total_price) from pizza_sales WHERE MONTH(order_date) = 1) 
AS Total_Percentage_Sales from pizza_sales           -- sum(total_price) as Total_Sales_for_Categories this will give the some Total sales price for different categories
WHERE MONTH(order_date) = 1
Group By(pizza_category)


-- If we give attention to percentage of sold pizzas in each category
/*select pizza_category , sum(quantity) *100 / (select sum(quantity) from pizza_sales)  AS PCT from pizza_sales
Group By(pizza_category)*/ -- This one is not corect

-- Percentage of Total_Sales By Pizza_Size
select pizza_size ,sum(total_price) as Total_Sales , sum(total_price)*100/(select sum(total_price) from pizza_sales)
as Total_Sales_per_size from pizza_sales
Group By(pizza_size)
order by Total_Sales_per_size desc  -- If we need the result with respect to descending order of Total_Sales_per_size

-- If we need the result[Total_Sales_per_size] up to two decimal points
select pizza_size ,sum(total_price) as Total_Sales , CAST(sum(total_price)*100/(select sum(total_price) from pizza_sales) as decimal(10,2))
as Total_Sales_per_size from pizza_sales
Group By(pizza_size)
order by Total_Sales_per_size

-- If we need the result[Total_Sales_per_size] and the  Total_Sales up to two decimal points
select pizza_size ,cast(sum(total_price)as decimal(10,2)) as Total_Sales  , CAST(sum(total_price)*100/(select sum(total_price) from pizza_sales) as decimal(10,2))
as Total_Sales_per_size from pizza_sales
Group By(pizza_size)
order by Total_Sales_per_size

-- If we calculate above sales only for January add the WHERE clause for it
select pizza_size ,cast(sum(total_price)as decimal(10,2)) as Total_Sales  , CAST(sum(total_price)*100/(select sum(total_price) from pizza_sales where DATEPART(QUARTER , order_date) = 1) as decimal(10,2))
as Total_Sales_per_size from pizza_sales
where DATEPART(QUARTER , order_date) = 1
Group By(pizza_size)
order by Total_Sales_per_size

-- Total Pizzas sold by pizza category with respect to sold total pizza
select pizza_category ,sum(quantity) as Total_Sales,  sum(quantity)*100/(select sum(quantity) from pizza_sales)
AS PCT from pizza_sales
Group By(pizza_category)

/*select pizza_category ,count(quantity) as Total_Sale_by_quantity from pizza_sales -- This one is wrong
Group By(pizza_category) -- count will gives the number of rows occur for a particular category not the total sum */

select pizza_category ,sum(quantity) as Total_Sale_by_sum from pizza_sales
Group By(pizza_category) -- sum will gives the total sum that mean total addition of sales with respect to pizza category


select * from pizza_sales
-- Top 5 best sellers by total pizza sold
select pizza_name , sum(quantity) as Total_Pizza_Sold_by_name from pizza_sales
group by(pizza_name) /*This will gives only the sum of different pizza_names*/

select TOP 5 pizza_name , sum(quantity) as Total_Pizza_Sold_by_name from pizza_sales
group by(pizza_name)
order by(Total_Pizza_Sold_by_name) /*This will gives only the sum of top 5 different pizza_names in ascending order*/

-- correct code
select TOP 5 pizza_name , sum(quantity) as Total_Pizza_Sold_by_name from pizza_sales
group by(pizza_name)
order by(Total_Pizza_Sold_by_name) DESC



--Bottom 5 worst sellers by total pizza sold
select TOP 5 pizza_name , sum(quantity) as Total_Pizza_Sold_by_name from pizza_sales
group by(pizza_name)
order by(Total_Pizza_Sold_by_name) 

-- To calculate for first month we can use where clause
select TOP 5 pizza_name , sum(quantity) as Total_Pizza_Sold_by_name from pizza_sales
WHERE MONTH(order_date) = 1
group by(pizza_name)
order by(Total_Pizza_Sold_by_name) 




-- Alternative method
/*SELECT pizza_name, Total_Pizza_Sold_by_name
FROM (
    SELECT pizza_name, 
           SUM(quantity) AS Total_Pizza_Sold_by_name
    FROM pizza_sales
    GROUP BY pizza_name
) AS SalesSummary
WHERE Total_Pizza_Sold_by_name = (
    SELECT MAX(Total_Pizza_Sold)
    FROM (
        SELECT SUM(quantity) AS Total_Pizza_Sold
        FROM pizza_sales
        GROUP BY pizza_name
    ) AS MaxSales
)*/
