--Cleaning 9 table by this step

--Order Table
--Explored Order Table
--Unwanted special characters and Errors in spelling
SELECT
  *
FROM
  `tonal-plasma-423323-c8.brazilian_ecommerce.orders`
LIMIT 10
;
--Evaluate Duplicate Row
SELECT 
  (SELECT COUNT(1) FROM `tonal-plasma-423323-c8.brazilian_ecommerce.orders`)  AS n_rows,
  (SELECT COUNT(1) FROM (SELECT DISTINCT * FROM `tonal-plasma-423323-c8.brazilian_ecommerce.orders`)) AS n_distinct_rows
--Evaluate Null value
SELECT 
  order_id,
  customer_id
FROM
  `tonal-plasma-423323-c8.brazilian_ecommerce.orders`
WHERE
  order_id is null or customer_id is null ;



