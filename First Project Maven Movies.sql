use mavenmovies;
													-- Q1
/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 
														-- The Solution
SELECT 
	staff.first_name AS manager_first_name, 
    staff.last_name AS manager_last_name,
    address.address, 
    address.district, 
    city.city, 
    country.country

FROM store
	LEFT JOIN staff ON store.manager_staff_id = staff.staff_id
    LEFT JOIN address ON store.address_id = address.address_id
    LEFT JOIN city ON address.city_id = city.city_id
    LEFT JOIN country ON city.country_id = country.country_id
;

----------------------------------------------------------------------------------------------------
															-- Q3
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/
														-- The Solution
select 
	i.store_id
    ,i.inventory_id
    ,f.title  name
    ,f.rating
    ,f.rental_rate
    ,f.replacement_cost

	
from inventory i
	inner join film f      on i.film_id = f.film_id;
    
----------------------------------------------------------------------------------------------------
														-- Q3
/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/													
                                                        -- The Solution
select 
	store_id
    ,rating
    ,count(inventory_id) 
    
from inventory i
	inner join film f 
    on i.film_id = f.film_id
    
group by store_id, rating
order by store_id;

------------------------------------------------------------------------------------------------------------------------------
														-- Q4
/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 
                                                        -- The Solution
select 
	store_id Store
    ,c.name Category_Name
	,count(inventory_id) Number_of_film
    ,AVG(replacement_cost) Average_Replacement_Cost
    ,SUM(replacement_cost) Total_Replacement_Cost

from inventory i
	inner join film f
    on i.film_id = f.film_id
	inner join film_category fc
    on f.film_id = fc.film_id
	inner join category c
    on fc.category_id = c.category_id
    
group by 
	store_id
    ,c.name

order by Total_Replacement_Cost desc;

---------------------------------------------------------------------------------------------------------
																-- Q5
/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/                                                                
                                                                -- The Solution

select
	first_name
    ,last_name
    ,active 
    ,c.store_id
    ,ad.address 
    ,city
    ,country

from customer c
    inner join address ad
    on c.address_id = ad.address_id
    inner join city ct 
    on ad.city_id = ct.city_id 
    inner join country co
    on ct.country_id = co.country_id;
    
---------------------------------------------------------------------------------------------------------
														-- Q6
/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/                                                        
                                                        -- The Solution

select 
	c.first_name                        --  rental    film 
    ,c.last_name
    ,count(r.rental_id) Total_Rental
	,sum(py.amount) Payment_Amount      -- amount     payment
from customer c
	inner join rental r
    on c.customer_id = r.customer_id
	inner join payment py
    on r.rental_id = py.rental_id

GROUP BY 
	c.first_name                                            --  rental    film 
    ,c.last_name
    
ORDER BY 
	Payment_Amount
    desc;
   
----------------------------------------------------------------------------------------------------------------
															 -- Q7
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/															
                                                             -- The Solution
select 
	"investor" as type
    ,first_name 
    ,lasr_name
    ,company_name
from investor

UNION

select
	"investor" as type
    ,first_name 
    ,lasr_name
    ,NULL
from advisor;

----------------------------------------------------------------------------------------------------------------
											 -- Q8
/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/
															 -- The Solution
SELECT
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END AS number_of_awards, 
    AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film
	
FROM actor_award
	

GROUP BY 
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END;
