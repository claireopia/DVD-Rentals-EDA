 /*Question 2
Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for. Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the rental duration for movies across all categories? Make sure to also indicate the category that these family-friendly movies fall into.
*/
WITH film_details
     AS (SELECT f. film_id,
                f.title AS film_title,
                c.NAME  AS film_category
           FROM film f
		   JOIN film_category fc
			 ON f.film_id = fc.film_id
		   JOIN category c
			 ON c.category_id = fc.category_id
          WHERE c.NAME IN ( 'Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music' )),
     rental_duration
     AS (SELECT inventory_id,
                LEFT(Cast(Date_trunc('day', return_date) - Date_trunc('day', rental_date) AS CHAR), 1) AS duration_days
           FROM rental
          WHERE return_date IS NOT NULL)
SELECT film_title,
       film_category,
       duration_days,
       Ntile(4) OVER (ORDER BY duration_days) AS duration_quartile
  FROM rental_duration rd
  JOIN inventory i
    ON rd.inventory_id = i.inventory_id
  JOIN film_details fd
    ON fd.film_id = i.film_id
 GROUP BY 1, 2, 3
 ORDER BY 4 DESC 