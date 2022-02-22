-- 1.create database
CREATE DATABASE IF NOT EXISTS house_price_regression;

-- 2/3.Create the table for the database
drop table if exists house_price_data;
CREATE TABLE `house_price_data` (
`id` bigint(64),
`date` DATE,
`bedrooms` bigint(64),
`bathrooms` decimal(10,2), -- float
`sqft_living` bigint(64),
`sqft_lot` bigint(64),
`floors` decimal(10,2), -- float
`waterfront` bigint(64),
`view` bigint(64),
`condition` bigint(64),
`grade` bigint(64),
`sqft_above` bigint(64),
`sqft_basement` bigint(64),
`yr_built` bigint(64),
`yr_renovated` bigint(64),
`zipcode` bigint(64),
`lat` decimal(10,2), -- float
`long` decimal(10,2), -- float
`sqft_living15` bigint(64),
`sqft_lot15` bigint(64),
`price` bigint(64))
ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8;

-- 4.check it data is actually imported (it is)
select*from regression_data_copy01;

-- 5.drop the column `date` from the database
ALTER TABLE regression_data_copy01 DROP date;

-- checking again if it dropped (it did)
select*from regression_data_copy01
limit 10;

/* 6.find how many rows of data you have
-- just counted a row to know how many i have */
select count(id) from regression_data_copy01;

-- 7.1 What are the unique values in the column `bedrooms`?
select distinct bedrooms from regression_data_copy01;

-- 7.2 What are the unique values in the column `bathrooms`?
select distinct bathrooms from regression_data_copy01;

-- 7.3 What are the unique values in the column `floors`?
select distinct floors from regression_data_copy01;

-- 7.4 What are the unique values in the column `condition`?
select distinct regression_data_copy01.condition from regression_data_copy01;

-- 7.5 What are the unique values in the column `grade`?
select distinct grade from regression_data_copy01;

/* 8. Arrange the data in a decreasing order by the price of the house. 
      Return only the IDs of the top 10 most expensive houses in your data. */
select * from regression_data_copy01
order by price desc
limit 10;

-- 9. What is the average price of all the properties in your data?
select avg(price) from regression_data_copy01;

/* 10.1 What is the average price of the houses grouped by bedrooms? 
   The returned result should have only two columns, bedrooms and Average of the prices. 
   Use an alias to change the name of the second column. */
select bedrooms, avg(price) as Average_bedroom_price from regression_data_copy01
group by bedrooms
order by price desc;

/* 10.2 What is the average `sqft_living` of the houses grouped by bedrooms?
   The returned result should have only two columns, bedrooms and Average of the `sqft_living`.
   Use an alias to change the name of the second column */
select bedrooms, avg(sqft_living) as Average_sqftLiving from regression_data_copy01
group by bedrooms
order by sqft_living desc;

/* 10.3 What is the average price of the houses with a waterfront and without a waterfront?
   The returned result should have only two columns, waterfront and `Average` of the prices.
   Use an alias to change the name of the second column. */
select waterfront, avg(price) as Average_price from regression_data_copy01
group by waterfront
order by price desc;

/* 10.4 Is there any correlation between the columns `condition` and `grade`?
   You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column.
   Visually check if there is a positive correlation or negative correlation or no correlation between the variables.*/
select grade, avg(regression_data_copy01.condition) from regression_data_copy01
group by grade
order by grade, regression_data_copy01.condition;

/* 10.5 You might also have to check the number of houses in each category (ie number of houses for a given `condition`)
   to assess if that category is well represented in the dataset to include it in your analysis.
   For eg. If the category is under-represented as compared to other categories, ignore that category in this analysis 
*/
select grade , count(id) as number_of_houses from regression_data_copy01
group by grade
order by grade asc;

select regression_data_copy01.condition as _condition , count(id) as number_of_houses from regression_data_copy01
group by regression_data_copy01.condition
order by regression_data_copy01.condition asc;

/* 11. One of the customers is only interested in the following houses:

    - Number of bedrooms either 3 or 4
    - Bathrooms more than 3
    - One Floor
    - No waterfront
    - Condition should be 3 at least
    - Grade should be 5 at least
    - Price less than 300000

    For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them?
*/
select * from regression_data_copy01
where bedrooms between 3 and 4
and floors = 1 and bathrooms > 3
and waterfront = 0 and regression_data_copy01.condition >= 3
and grade >= 5 and price < 300000;

/* 12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database.
    Write a query to show them the list of such properties. You might need to use a sub query for this problem. */
select * from regression_data_copy01
where price > 2*(
select avg(price) from regression_data_copy01);
    
/* 13. Since this is something that the senior management is regularly interested in,
   create a view called `Houses_with_higher_than_double_average_price` of the same query. */
create view Houses_with_higher_than_double_average_price as
select * from regression_data_copy01
where price > 2*(
select avg(price) from regression_data_copy01);

select * from Houses_with_higher_than_double_average_price;

/* 14. Most customers are interested in properties with three or four bedrooms.
   What is the difference in average prices of the properties with three and four bedrooms?
   In this case you can simply use a group by to check the prices for those particular houses */
select bedrooms , avg(price) from regression_data_copy01
where bedrooms between 3 and 4
group by bedrooms;

-- 15. What are the different locations where properties are available in your database? (distinct zip codes)
select distinct zipcode from regression_data_copy01;

-- 16. Show the list of all the properties that were renovated.
select * from regression_data_copy01
where yr_renovated != 0;

-- 17. Provide the details of the property that is the 11th most expensive property in your database.
select * from
(select * from regression_data_copy01
order by price desc) sub1
limit 10,1;

