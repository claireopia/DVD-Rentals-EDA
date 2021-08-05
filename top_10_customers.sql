 /* Question 2
We would like to know who were our top 10 paying customers, how many payments they made on a monthly basis during 2007, and what
was the amount of the monthly payments. Can you write a query to capture the customer name, month and year of payment, and total
payment amount for each month by these top 10 paying customers?
*/
WITH top_10 
		  AS (SELECT  c.customer_id,
					  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
					  COUNT(*) AS pay_count,
					  SUM(amount) AS total_payment
				 FROM payment p
				 JOIN customer c
				   ON p.customer_id = c.customer_id
				GROUP BY 1, 2
				ORDER BY 4 DESC limit 10)
SELECT DATE_TRUNC('month', payment_date) AS payment_month,
	   customer_name,
	   COUNT(pay_count) AS payment_count,
	   SUM(amount) AS total_monthly_payment
  FROM payment p
  JOIN top_10 t1
    ON p.customer_id = t1.customer_id
 GROUP BY 1, 2
 ORDER BY 2, 1 