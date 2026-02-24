
---------------------------------------- Geographic Trends -------------------------------------------------

-- 1. Which countries or cities have the highest number of customers?

SELECT country, city, COUNT(customer_id) AS customer_count
FROM customer
GROUP BY country, city
ORDER BY customer_count DESC;


-- 2. How does revenue vary by region?

SELECT billing_country, billing_state, SUM(total) AS total_revenue
FROM invoice
GROUP BY billing_country, billing_state
ORDER BY total_revenue DESC;


-- 3. Are there any underserved geographic regions (high users, low sales)?

WITH customer_counts AS (
        SELECT 
          country, city,
          COUNT(customer_id) AS total_customers
        FROM customer
        GROUP BY country, city 
),
     region_revenue AS (
        SELECT 
            billing_country AS country,
            billing_state AS city,
            SUM(total) AS total_revenue
        FROM invoice
        GROUP BY country, city
)

SELECT 
    c.country,
    c.city,
    c.total_customers,
    COALESCE(r.total_revenue, 0) AS total_revenue,
    ROUND(COALESCE(r.total_revenue, 0) / c.total_customers, 2) AS revenue_per_customer
FROM customer_counts c
LEFT JOIN region_revenue r
    ON c.country = r.country
   AND c.city = r.city
ORDER BY revenue_per_customer;
