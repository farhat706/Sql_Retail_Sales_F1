#Data cleaning 
SELECT * from retail_sales_tb
where 
	transactions_id is null
    or sale_date is null
    or sale_time is null
    or customer_id is null
    or gender is null
    or age is null
    or category is null
    or quantiy is null
    or price_per_unit is null
    or cogs is null
    or total_sale is null;
    
    # Data exploration
    
    #How many sales we have
    select count(*) as total_sales from retail_sales_tb;
    
    #How many customers we have
    select count(distinct customer_id) as total_customers from retail_sales_tb;
    
    #How many category we have
    select count(distinct category ) as total_category from retail_sales_tb;
    
    # find category name
    select distinct category from retail_sales_tb;
    
    
# Data analysis & business questions

# 1. write a sql query to retrieve all columns on sales made on 2022-11-05
select * 
from retail_sales_tb
where sale_date = '2022-11-05';

# 2.  write a sql query to retrieve all transactions where category is 'clothing'& the quantiy sold is more than 4 in month 
#     of nov-2022
SELECT *
FROM retail_sales_tb
WHERE category = 'Clothing'
AND quantiy >=4
AND sale_date >= '2022-11-01'
AND sale_date < '2022-12-01';

# 3. write a sql query to calculate total sales for each category and total orders
select category, sum(total_sale) as net_sales, count(*) as total_orders
from retail_sales_tb
group by 1;

# 4. write a sql query to calculate age of customers who purchased items from beauty category
select round(avg(age),2) as avg_age
from retail_sales_tb
where category ='beauty';

# 5. write a sql query to find all transactions where the total_sales is greater than 1000
select * from retail_sales_tb
where total_sale > 1000;

# 6. write a sql query to find total number of transactions_id made by each gender in each category
select category, gender,count(*) as total_transactions
from retail_sales_tb
group by 1,2
order by 1;

# 7. write a sql query to calculate avg sales for each month. find out best selling month in each year ( important question )
select years, months,avg_sale
from 
(select 
    year(sale_date) as years,
    month(sale_date) as months,
    avg(total_sale) as avg_sale,
    rank() over(partition by year(sale_date) order by avg (total_sale) desc) as rnk
from retail_sales_tb
group by 1,2) as t1
where rnk = 1;

# 8. write a sql query to find top 5 customers based on hightest total sales
select customer_id, sum(total_sale) as highest_sales
from retail_sales_tb
group by 1
order by 2 desc
limit 5; 

# 9. write a sql query to fid unique customers who purchased items from each category.
select category, count(distinct customer_id) as unique_customers
from retail_sales_tb
group by 1;

# 10. write a sql query to create each shift and number of orders
with hourly_sales as
(select *,
    case
	  when hour(sale_time) <12 then 'Morning'
      when hour(sale_time) between 12 and 17 then 'Afternoon'
      else 'Evening'
      end as shifts
from retail_sales_tb)
select shifts, count(*) as total_orders
from hourly_sales
group by 1;