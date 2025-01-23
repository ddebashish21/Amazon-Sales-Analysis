select * from amazon;

-- What is the count of distinct cities in the dataset?
select count(distinct City) as Distinct_city_count from amazon;

-- For each branch, what is the corresponding city?
select distinct Branch, City from amazon;

-- What is the count of distinct product lines in the dataset?
select count(distinct `Product line`) as 'Distinct Product Line' from amazon;

-- Which payment method occurs most frequently?
select Payment, count(Payment) as count_of_payment_mode from amazon group by Payment order by count_of_payment_mode desc limit 1;

-- Which product line has the highest sales?
select `Product line`, sum(Total) as Total_sales from amazon group by `Product line` order by Total_sales desc limit 1;

-- Creating temporary table with additional info
create temporary table amazon_sales_addtion_info
select *, case 
when extract(hour from Time)<12 then 'Morning' 
when extract(hour from Time)>=17 then 'Evening' 
when extract(hour from Time)>=12 and extract(hour from Time)<17 then 'Afternoon'
else 'Unknown'
end  as TimeOfDay, dayname(Date) as DayName, monthname(Date) as MonthName from amazon;

select * from amazon_sales_addtion_info;

-- How much revenue is generated each month?
select MonthName, round(sum(`gross income`),2) as Revenue_Per_Month from amazon_sales_addtion_info group by MonthName;

-- In which month did the cost of goods sold reach its peak?
select MonthName, round(sum(cogs),2) as Cogs_Per_Month from amazon_sales_addtion_info group by MonthName order by Cogs_Per_Month desc limit 1;

-- Which product line generated the highest revenue?
select `product line`, round(sum(`gross income`),2) as revenue from amazon_sales_addtion_info group by `product line` order by revenue desc limit 1;

-- In which city was the highest revenue recorded?
select City , round(sum(`gross income`),2) as revenue from amazon_sales_addtion_info group by City order by revenue desc limit 1;

-- Which product line incurred the highest Value Added Tax?
select `product line`, round(sum(`Tax 5%`),2) as Value_added_tax from amazon_sales_addtion_info group by `product line` order by Value_added_tax desc limit 1;

-- For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
select `product line`, 
case
when sum(`Total`)>(Select sum(Total)/count(Distinct `product line`) from amazon) then 'Good'
else 'Bad'
end as Sales from amazon_sales_addtion_info group by `product line`;

-- Identify the branch that exceeded the average number of products sold.
select `Branch`, `City` from amazon_sales_addtion_info group by `Branch`, `City` having sum(`Quantity`)>(select sum(`Quantity`)/count(distinct `Branch`) from amazon);

-- Which product line is most frequently associated with each gender?
select `product line`, `gender`, count(`gender`) as number_of_customers from amazon_sales_addtion_info group by `product line`, `gender` order by `product line`, number_of_customers desc;

-- Calculate the average rating for each product line.
select `product line`, round(avg(`rating`),2) as Ratings from amazon_sales_addtion_info group by `product line` order by Ratings desc;

-- Count the sales occurrences for each time of day on every weekday.
select DayName, TimeOfDay, count(*) as sales_count from amazon_sales_addtion_info where DayName!='Sunday' group by DayName, TimeOfDay order by DayName, TimeOfDay;

-- Identify the customer type contributing the highest revenue.
select `Customer type`, round(sum(`gross income`),2) as revenues from amazon_sales_addtion_info group by `customer type` order by revenues desc;

-- Determine the city with the highest VAT percentage.
select `city`, round((sum(`Tax 5%`)*100/(select sum(`Tax 5%`) from amazon)),2) as VAT from amazon_sales_addtion_info group by `city` order by VAT desc limit 1;

-- Identify the customer type with the highest VAT payments.
select `Customer type`, round(sum(`Tax 5%`),2) as VAT from amazon_sales_addtion_info group by `customer type` order by VAT desc limit 1;

-- What is the count of distinct customer types in the dataset?
select count(distinct `Customer type`) as Number_of_customer_types from amazon_sales_addtion_info;

-- What is the count of distinct payment methods in the dataset?
select count(distinct `payment`) as Number_of_payment_methods from amazon_sales_addtion_info;

-- Which customer type occurs most frequently?
select `Customer type`, count(*) as frequency from amazon_sales_addtion_info group by `customer type`;

-- Identify the customer type with the highest purchase frequency.
select `Customer type`, count(`Total`) as frequency_of_purchase from amazon_sales_addtion_info group by `customer type`;

-- Determine the predominant gender among customers.
select `Gender`, count(*) as Number_of_customers from amazon_sales_addtion_info group by `gender`;

-- Examine the distribution of genders within each branch.
select `City`, `Branch`, `Gender`, count(*) as Number_of_customers from amazon_sales_addtion_info group by `city`, `Branch`, `gender` order by `Branch`;

-- Identify the time of day when customers provide the most ratings.
select TimeOfDay, count(`Rating`) as Number_of_ratings from amazon_sales_addtion_info group by TimeOfDay order by Number_of_ratings desc limit 1;

-- Determine the time of day with the highest customer ratings for each branch.
select `City`, `Branch`, `TimeOfDay`, count(`Rating`) as Number_of_ratings from amazon_sales_addtion_info group by `City`, `Branch`, `TimeOfDay` order by `City`, Number_of_ratings desc;

-- Identify the day of the week with the highest average ratings.
select DayName, avg(`Rating`) as avg_rating from amazon_sales_addtion_info group by DayName order by avg_rating desc limit 1;

-- Determine the day of the week with the highest average ratings for each branch.
select `City`, `Branch`, `DayName`, avg(`Rating`) as avg_rating from amazon_sales_addtion_info group by `City`, `Branch`, `DayName` order by `City`, avg_rating desc;

-- Ratings of each branch
select `Branch`, avg(`Rating`) as avg_rating from amazon_sales_addtion_info group by `Branch`;