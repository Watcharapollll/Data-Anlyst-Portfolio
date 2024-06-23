--This query will use for retrieving data from database into Power BI
--Use in visualize Top artist revenue 
SELECT 
    ar.name AS artist_name, 
    SUM(il.unit_price * il.quantity) AS total_revenue
FROM 
    invoice_line il
LEFT JOIN 
    track t ON il.track_id = t.track_id
LEFT JOIN 
    album al ON t.album_id = al.album_id
LEFT JOIN 
    artist ar ON al.artist_id = ar.artist_id
GROUP BY 
    ar.artist_id, ar.name
ORDER BY 
    total_revenue DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

--Use in visualize Most album by artist
SELECT 
    ar.name AS artist_name, 
    COUNT(al.album_id) AS album_count
FROM 
    album al
LEFT JOIN 
    artist ar ON al.artist_id = ar.artist_id
GROUP BY 
    ar.artist_id, ar.name
ORDER BY 
    album_count DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;


--Use in visualize Revenue by genre
SELECT TOP 10
    g.name AS genre_name, 
    SUM(il.unit_price * il.quantity) AS total_sales
FROM 
    invoice_line il
LEFT JOIN 
    track t ON il.track_id = t.track_id
LEFT JOIN 
    genre g ON t.genre_id = g.genre_id
GROUP BY 
    g.genre_id, g.name
ORDER BY 
    total_sales DESC;

--Use in visualize Top country by transaction
SELECT top 10 
    c.country AS country, 
    COUNT(i.invoice_id) AS transaction_count
FROM 
    invoice i
LEFT JOIN 
    customer c ON i.customer_id = c.customer_id
GROUP BY 
    c.country
ORDER BY 
    transaction_count DESC;

--Use in visualize Total sale over year by quarter
SELECT
	a.invoice_date,
	SUM(b.unit_price * b.quantity) AS total_sales
FROM invoice a
LEFT JOIN invoice_line  b on a.invoice_id = b.invoice_id
group by invoice_date
