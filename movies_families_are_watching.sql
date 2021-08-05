/* Question 1
We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music. 
Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.
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
         WHERE  c.NAME IN ( 'Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music' ))
SELECT DISTINCT film_title,
	   film_category,
	   COUNT(r.*) AS rental_count
  FROM rental r
  JOIN inventory i
    ON r.inventory_id = i.inventory_id
  JOIN film_details fd
    ON fd.film_id = i.film_id
 GROUP BY 1, 2
 ORDER BY 2, 1  
