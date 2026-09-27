drop table if exists zepto;

Create table zepto(
sku_id SERIAL PRIMARY KEY,
Category varchar(120),
name varchar(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--data exploration

--count of rows
Select count(*)
From zepto ;

--sample data
select * 
from zepto
limit 10;

--null value
Select * from zepto
where name IS NULL
or
category IS NULL
or
mrp IS NULL
or
discountpercent IS NULL
or
availablequantity IS NULL
or
discountedsellingprice IS NULL
or
weightingms IS NULL
or
outofstock IS NULL
or
quantity IS NULL;

--different product category

Select distinct category
from zepto
group by category ;

--products out of stock

Select outofstock,count(sku_id)
from zepto
group by outofstock;

--products present multiple times

select name, count(sku_id) as "Number of SKUs"
from zepto
Group by name
Having count (sku_id) > 1
order by count (sku_id) Desc
limit 10;

--data cleaning
-- products with price zero

Select *
from zepto
Where mrp = 0 or discountedsellingprice = 0;

Delete
From zepto
where sku_id = 3607;

Select *
from zepto
Where mrp = 0 or discountedsellingprice = 0;

--Converting paisa into rupees
Update zepto
set mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

select mrp, discountedsellingprice
from zepto;

-- Business Analysis Questions

-- Q1. Find the top 10 best-value products based on the discount percentage.
Select Distinct name, mrp, discountpercent
from zepto
Order by discountpercent desc
limit 10;


--Q2.What are the Products with High MRP but Out of Stock

Select Distinct name, mrp
from zepto
where outofstock = true
Order by mrp desc
limit 10;

--Q3.Calculate Estimated Revenue for each category

select category,
sum(discountedsellingprice * availablequantity) as total_revenue
from zepto
group by category
order by total_revenue ;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

Select distinct name, mrp, discountpercent
From zepto
Where mrp > 500 and discountpercent < 10
Order by mrp desc, discountpercent desc
limit 10;


-- Q5. Identify the top 5 categories offering the highest average discount percentage.

Select category,
Round(AVG(discountpercent),2) as avg_discount
from zepto
Group by category
order by avg_discount Desc
limit 5 ;

-- Q6. Find the price per gram for products above 100g and sort by best value.

Select distinct name, weightingms, discountedsellingprice,
Round(discountedsellingprice/weightingms,2) as price_per_gram
From zepto
Where weightingms >= 100
Order by price_per_gram desc;


--Q7.Group the products into categories like Low, Medium, Bulk.

Select distinct name, weightingms,
CASE WHEN weightingms < 1000 THEN 'LOW'
     WHEN weightingms < 5000 THEN 'MEDIUM'
	 ELSE 'HIGH'
	 END as weight_category
From zepto;	 


--Q8.What is the Total Inventory Weight Per Category 

Select category,
SUM(weightingms * availablequantity) as total_weight
from zepto
Group by category
Order by total_weight;


