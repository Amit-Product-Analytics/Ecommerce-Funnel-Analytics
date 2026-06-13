Create database Ecommerce_Product_Analytics ;
use ecommerce_product_analytics;
select * from ecommerce_user_behavior;
-- =====================================================
-- PRODUCT ANALYTICS PORTFOLIO PROJECT
-- Dataset: Ecommerce User Behavior
-- Author: Amit Kumar
-- =====================================================


-- =====================================================
-- SECTION 1 : BUSINESS METRICS
-- =====================================================

-- Query 1 : Total Users
select 
count(distinct customer_id)  as total_user
from ecommerce_user_behavior;


-- Query 2 : Total Revenue
select
sum(revenue)as total_revenue
from ecommerce_user_behavior;

-- Query 3 : Total Orders

SELECT COUNT(*) AS total_orders
FROM ecommerce_user_behavior
WHERE purchase_completed = 'Yes';

-- Query 4 : Average Order Value (AOV)
SELECT
SUM(revenue) AS total_revenue,
COUNT(*) AS total_orders,
ROUND(
SUM(revenue)/COUNT(*)
,2) AS AOV
FROM ecommerce_user_behavior
WHERE purchase_completed='Yes';

-- Query 5 : Total Traffic
select
traffic_source,
count(distinct customer_id ) as Total_user_on_traffic_source
from ecommerce_user_behavior
group by 1
order by 2 desc;

-- Query 6 : Total Device
select
device_type,
count(distinct customer_id ) as Total_user_on_device_type
from ecommerce_user_behavior
group by 1
order by 2 desc;

-- Query 7 : Total Payment Method
select
payment_method,
count(distinct customer_id ) as Total_user_on_payment_method
from ecommerce_user_behavior
group by 1
order by 2 desc;


-- =====================================================
-- SECTION 2 : FUNNEL ANALYSIS
-- =====================================================

-- Query 8 : Add To Cart Rate
select 
count(case when add_to_cart='yes'then 1 else 0 end)*100/
count(*) as add_to_cart_converstion_rate
from ecommerce_user_behavior;

-- Query 9  : converstion Rate
select 
round(count(case when purchase_completed='yes'then 1 else 0 end)*100/
count(*),2) as converstion_rate
from ecommerce_user_behavior;

-- Query 10 : Funnel Summary

select
sum(case when add_to_cart ='yes' then 1 else 0 end) as Total_Member_in_cart,
sum(case when checkout_started='yes' then 1 else 0 end) as Total_Member_in_checkout,
sum(case when purchase_completed ='yes' then 1 else 0 end) as Total_Member_in_purchased
from ecommerce_user_behavior;

-- =====================================================
-- SECTION 3 : MARKETING ANALYTICS
-- =====================================================

-- Query 11 : Traffic Source Performance

select
traffic_source,
count(distinct customer_id) as vistors
from ecommerce_user_behavior
group by 1
order by 1 desc;


-- Query 12 : Conversion Rate By Traffic Source

select
traffic_source,
count(distinct customer_id) as vistors,
sum(case when purchase_completed ='yes' then 1 else 0 end)as buyers,
round(sum(case when purchase_completed ='yes' then 1 else 0 end)*100/count(distinct customer_id),2)as Traffic_conversion_rate
from ecommerce_user_behavior
group by 1
order by 1 desc;

-- Query 13 : Revenue By Traffic Source

select
traffic_source,
count(distinct customer_id)as vistors,
sum(case when purchase_completed = 'yes' then 1 else 0 end)as buyers,
sum(revenue) as Total_cost
from ecommerce_user_behavior
group by 1
order by 1 desc;

-- =====================================================
-- SECTION 4 : PRODUCT ANALYTICS
-- =====================================================

-- Query 14 : Revenue By Product Category

select
product_category,
count(distinct customer_id)as Items,
sum(case when purchase_completed = 'yes' then 1 else 0 end)as buyers,
sum(revenue)as Total_cost,
ROUND(
100.0 * SUM(revenue)
/
SUM(SUM(revenue)) OVER()
,2
)AS revenue_share_percent

from ecommerce_user_behavior
group by 1
order by 1 desc;


-- Query 15 : Conversion Rate By Product Category
select
product_category,
count(distinct customer_id)as Items,
sum(case when purchase_completed = 'yes' then 1 else 0 end)as buyers,
round(sum(case when purchase_completed = 'yes' then 1 else 0 end)*100/count(distinct customer_id),2) as Conversion_rate_by_Product
from ecommerce_user_behavior
group by 1
order by 1 desc;


-- =====================================================
-- SECTION 5 : USER BEHAVIOR ANALYTICS
-- =====================================================

-- Query 16 : Device Performance

select
device_type,
count(distinct customer_id) as users,
sum(case when purchase_completed ='yes' then 1 else 0 end)as Buyers
from ecommerce_user_behavior
group by 1
order by 1 desc;

select
device_type,
avg(session_duration)as avg_per_session,
avg(pages_viewed)as avg_per_page
from ecommerce_user_behavior
group by 1
order by 1 desc;

-- Query 17 : User Engagement Analysis

select
purchase_completed,
avg(session_duration)as avg_per_session,
avg(pages_viewed)as avg_per_page
from ecommerce_user_behavior
group by 1
order by 1 desc;

-- =====================================================
-- SECTION 6 : CUSTOMER ANALYTICS
-- =====================================================

-- Query 18 : New Vs Returning Users

select
customer_type ,
count(distinct customer_id ) as users
from ecommerce_user_behavior
group by 1
order by 1 desc;

-- Query 19 : Revenue By Customer Type
select
customer_type ,
count(distinct customer_id ) as users,
sum(case when purchase_completed = 'yes'then 1 else 0 end)as buyers,
sum(revenue)as Total_cost
from ecommerce_user_behavior
group by 1
order by 1 desc;

-- Query 20 : Conversion Rate By Customer Type
select
customer_type ,
count(distinct customer_id ) as users,
sum(case when purchase_completed = 'yes'then 1 else 0 end)as buyers,
sum(revenue)as Total_cost,
sum(case when purchase_completed = 'yes'then 1 else 0 end)*100/count(distinct customer_id ) as Convertion_by_Customer_type
from ecommerce_user_behavior
group by 1
order by 1 desc;


-- =====================================================
-- SECTION 7 : CART ABANDONMENT ANALYSIS
-- =====================================================

-- Query 21 : Cart Abandonment Rate

select
cart_abandoned,
count(distinct customer_id) as users,
sum(case when cart_abandoned = 'yes'then 1 else 0 end)as buyers,
sum(case when cart_abandoned = 'yes'then 1 else 0 end)*100/count(* ) as cart_abandonment_rate
from ecommerce_user_behavior
group by 1
order by 1 desc;

SELECT
ROUND(
100.0 *
SUM(CASE WHEN cart_abandoned='Yes' THEN 1 ELSE 0 END)
/ COUNT(*)
,2) AS cart_abandonment_rate
FROM ecommerce_user_behavior;
-- Query 21 :Checkout Abandonment
SELECT
ROUND(
100.0 *
SUM(
CASE
WHEN checkout_started='Yes'
AND purchase_completed='No'
THEN 1
ELSE 0
END
)
/
SUM(
CASE
WHEN checkout_started='Yes'
THEN 1
ELSE 0
END
)
,2) AS checkout_abandonment_rate
FROM ecommerce_user_behavior;


-- Query 22 : Cart Abandonment By Device

SELECT
device_type,
SUM(CASE WHEN cart_abandoned='Yes' THEN 1 ELSE 0 END) AS abandoned_carts
FROM ecommerce_user_behavior
GROUP BY device_type;


-- =====================================================
-- SECTION 8 : DISCOUNT ANALYSIS
-- =====================================================

-- Query 23 : Discount Impact

SELECT
discount_applied,
COUNT(*) AS users,
SUM(revenue) AS revenue
FROM ecommerce_user_behavior
GROUP BY discount_applied;


-- =====================================================
-- SECTION 9 : GEOGRAPHIC ANALYSIS
-- =====================================================

-- Query 24 : Revenue By City

SELECT
city,
count(distinct customer_id)as user,
SUM(CASE WHEN purchase_completed='Yes' THEN 1 ELSE 0 END) as buyers,
SUM(revenue) AS revenue
FROM ecommerce_user_behavior
GROUP BY city
ORDER BY revenue DESC
;
-- Query 24.1 : Revenue By City  Dense Rank
SELECT
city,
SUM(revenue) AS revenue,
DENSE_RANK() OVER(
ORDER BY SUM(revenue) DESC
) AS city_rank
FROM ecommerce_user_behavior
GROUP BY city;

-- Query 25 : Conversion Rate By City

SELECT
city,
ROUND(
100.0 *
SUM(CASE WHEN purchase_completed='Yes' THEN 1 ELSE 0 END)
/ COUNT(*)
,2) AS conversion_rate
FROM ecommerce_user_behavior
GROUP BY city
ORDER BY conversion_rate DESC;

-- Query 26 : Conversion Rate By City

SELECT
city,
count(distinct customer_id)as users,
SUM(CASE WHEN purchase_completed='Yes' THEN 1 ELSE 0 END) as buyers,
SUM(revenue) AS revenue,
SUM(CASE WHEN purchase_completed='Yes' THEN 1 ELSE 0 END)*100/count(distinct customer_id)AS conversion_rate
FROM ecommerce_user_behavior
GROUP BY city
ORDER BY conversion_rate DESC;

-- Query 27 : Best Traffic Source


WITH traffic_revenue AS
(
SELECT
traffic_source,
SUM(revenue) AS revenue
FROM ecommerce_user_behavior
GROUP BY traffic_source
)

SELECT *
FROM traffic_revenue
ORDER BY revenue DESC;
































































