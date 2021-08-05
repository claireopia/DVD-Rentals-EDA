/* Question 3
Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly payments
during 2007. Please go ahead and write a query to compare the payment amounts in each successive month. Repeat this for
each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name who paid the most
difference in terms of payments.
*/
WITH top_10 
	   AS (SELECT c.customer_id,
				  c.first_name || ' ' || c.last_name AS customer_name,
				  SUM(amount) AS total_payment
			 FROM payment p
			 JOIN customer c ON p.customer_id = c.customer_id
		 	GROUP BY 1, 2
		 	ORDER BY 3 DESC
			LIMIT 10),
	monthly_pay
	   AS (SELECT DATE_TRUNC('month', payment_date) AS payment_month,
				  customer_id,
				  SUM(amount) AS monthly_payment,
				  COALESCE (LAG(SUM(amount)) OVER (PARTITION BY customer_id ORDER BY DATE_TRUNC('month', payment_date)), 0) AS prev_month_payment
		   	 FROM payment p
		 GROUP BY 1, 2)
SELECT payment_month,
	   customer_name,
	   monthly_payment - prev_month_payment AS monthly_payment_diff
  FROM monthly_pay mp
  JOIN top_10 t1 ON mp.customer_id = t1.customer_id
 ORDER BY 3 DESC