--Every query will extract a time stamp for the time filter in dashboard.


--Query Orders by Category
SELECT 
  a.product_category_name_english AS category_name,
  COUNT(DISTINCT c.order_id) AS total_orders,
  EXTRACT(YEAR FROM d.order_purchase_timestamp) AS year,
  EXTRACT(MONTH FROM d.order_purchase_timestamp) AS month,
  EXTRACT(QUARTER FROM d.order_purchase_timestamp) AS quarter
FROM 
  `tonal-plasma-423323-c8.brazilian_ecommerce.category_name_translation` a
JOIN 
  (SELECT
    product_category_name,
    product_id
    FROM`tonal-plasma-423323-c8.brazilian_ecommerce.products`) b
  ON a.product_category_name = b.product_category_name
JOIN 
  (SELECT
    product_id,
    order_id
    FROM`tonal-plasma-423323-c8.brazilian_ecommerce.order_items`) c
  ON b.product_id = c.product_id
JOIN 
  (SELECT 
     order_id,
     order_purchase_timestamp
   FROM 
     `tonal-plasma-423323-c8.brazilian_ecommerce.orders`
  ) d
  ON c.order_id = d.order_id
GROUP BY 
  category_name, year, month, quarter
ORDER BY 
  year, month, quarter, category_name;


--Heat map of density order
SELECT 
  a.geolocation_lat AS latitude,
  a.geolocation_lng AS longitude,
  COUNT(c.order_id) AS order_count,
  EXTRACT(YEAR FROM c.order_purchase_timestamp) AS year,
  EXTRACT(MONTH FROM c.order_purchase_timestamp) AS month,
  EXTRACT(QUARTER FROM c.order_purchase_timestamp) AS quarter
FROM 
  (SELECT
      geolocation_lat,
      geolocation_lng,
      geolocation_zip_code_prefix
    FROM`tonal-plasma-423323-c8.brazilian_ecommerce.geolocation`) a
JOIN 
  (SELECT
      customer_zip_code_prefix,
      customer_id
    FROM `tonal-plasma-423323-c8.brazilian_ecommerce.customer`) b
ON 
  a.geolocation_zip_code_prefix = b.customer_zip_code_prefix
JOIN
  (SELECT
    customer_id,
    order_id,
    order_purchase_timestamp
    FROM`tonal-plasma-423323-c8.brazilian_ecommerce.orders`)c
ON
  b.customer_id = c.customer_id
GROUP BY 
  latitude,longitude, year, month, quarter
ORDER BY 
  year, month, quarter,latitude,longitude;


--Sale over a year
SELECT 
  EXTRACT(YEAR FROM b.order_purchase_timestamp) AS year,
  EXTRACT(MONTH FROM b.order_purchase_timestamp) AS month,
  EXTRACT(QUARTER FROM b.order_purchase_timestamp) AS quarter,
  SUM(a.payment_value) AS total_sales
FROM 
  `tonal-plasma-423323-c8.brazilian_ecommerce.order_payments` a
JOIN
  `tonal-plasma-423323-c8.brazilian_ecommerce.orders` b
ON 
  a.order_id = b.order_id
  GROUP BY 
  year, month, quarter
ORDER BY 
  year, month, quarter;


--Total sellers
SELECT 
  EXTRACT(YEAR FROM b.order_purchase_timestamp) AS year,
  EXTRACT(MONTH FROM b.order_purchase_timestamp) AS month,
  EXTRACT(QUARTER FROM b.order_purchase_timestamp) AS quarter,
  COUNT(DISTINCT a.seller_id) AS total_sellers
FROM 
  `tonal-plasma-423323-c8.brazilian_ecommerce.order_items` a
JOIN
  `tonal-plasma-423323-c8.brazilian_ecommerce.orders` b
ON 
  a.order_id = b.order_id
GROUP BY 
  year, month, quarter
ORDER BY 
  year, month, quarter;


--Total order
SELECT 
  EXTRACT(YEAR FROM b.order_purchase_timestamp) AS year,
  EXTRACT(MONTH FROM b.order_purchase_timestamp) AS month,
  EXTRACT(QUARTER FROM b.order_purchase_timestamp) AS quarter,
  COUNT(DISTINCT a.order_id) AS total_orders
FROM 
  `tonal-plasma-423323-c8.brazilian_ecommerce.orders` a
JOIN
  `tonal-plasma-423323-c8.brazilian_ecommerce.orders` b
ON 
  a.order_id = b.order_id
GROUP BY 
  year, month, quarter
ORDER BY 
  year, month, quarter;

--Total customer
SELECT 
  COUNT(DISTINCT a.customer_unique_id) AS total_customers,
  EXTRACT(YEAR FROM b.order_purchase_timestamp) AS year,
  EXTRACT(MONTH FROM b.order_purchase_timestamp) AS month,
  EXTRACT(QUARTER FROM b.order_purchase_timestamp) AS quarter
FROM 
  `tonal-plasma-423323-c8.brazilian_ecommerce.customer`a
JOIN
  `tonal-plasma-423323-c8.brazilian_ecommerce.orders` b
ON 
  a.customer_id = b.customer_id
GROUP BY 
  year, month, quarter
ORDER BY 
  year, month, quarter;

 