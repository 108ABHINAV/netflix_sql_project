# 1. Count the number of Movies vs TV Shows
select 
	type_name,
    count(*) total_content
from netflix 
group by type_name;

# 2. Find the most common rating for movies and TV shows
select type_name,rating
from
(
	select
		type_name,
        rating,
        count(*),
		rank() over(partition by type_name order by count(*) desc) as ranking
	from netflix
	group by type_name,rating
) as t1
where ranking =1
;

# 3. List all movies released in a specific year (e.g., 2020)
select 
	title as Movie_Name
from netflix
where 
	type_name like 'Movie' 
    and release_year=2020;

# 4. Find the top 5 countries with the most content on Netflix
select 
	distinct trim(country_new),
    count(*) as total_content
from(
	select 
		show_id,
		jt.country_new
	from netflix n,	
	json_table(
		concat('["',replace(n.country,',','","'),'"]'),
		'$[*]' columns (country_new varchar(50) path '$')
	)as jt
)t
where country_new is not null and country_new !=''
group by country_new
order by total_content desc
limit 5;

# 5. Identify the longest movie
select 
	title, 
    duration
from netflix
where type_name = 'Movie'
order by substring(duration,1,INSTR(duration," ")-1) desc
limit 1;

# 6. Find content added in the last 5 years
select 
	date_added
from netflix
where date_added<date_sub(curdate(),interval 5 year);

# 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select * 
from netflix
where director like '%Rajiv Chilaka%' 
;

# 8. List all TV shows with more than 5 seasons
select 
	title,
    duration 
from netflix
where type_name like 'TV Show' 
	and substr(duration,1,instr(duration,' ')-1)>5;

# 9. Count the number of content items in each genre
select 
	distinct trim(genre),
    count(*) as total_count
from(
    select 
		show_id,
		jt.genre
	from netflix n,
	json_table(
		concat('["',replace(n.listed_in,',','","'),'"]'),
		'$[*]' columns (genre varchar(50) path '$')
	)as jt
)t
group by genre
order by total_count desc;
/*
#10.Find each year and the average numbers of content release in India on netflix.return top 5 year with highest avg content release!
-- Find top 5 years with highest number of Indian releases and their percentage share
*/
select
	country,
	release_year,
	count(show_id) as total_release,
	round(
		count(show_id)/
		(select 
			count(show_id)
		from netflix
		where country like 'india'
		)*100,
		2
	)as avg_release
from netflix
where country = 'india'
group by country,release_year
order by avg_release desc
limit 5;

# 11. List all movies that are documentaries
select title
from netflix
where type_name like 'Movie' 
	and listed_in like '%documentaries%';

# 12. Find all content without a director
select * 
from netflix
where director is null 
	or director like '';

# 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select 
	count(*) as total_movies
from netflix
where casts like '%salman khan%' 
	and date_added < date_sub(curdate(),interval 10 year);

# 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
	distinct trim(casts_new) as actors,
	count(*) as total_apperance
from 
(
select 
	show_id,
	casts_new,
	country
from netflix n,
	json_table(
		concat('["',replace(n.casts,',','","'),'"]'),
		'$[*]' columns (casts_new varchar(50) path '$')
	)as jt
)t
where country like 'india' 
	and casts_new is not null 
    and casts_new != ''
group by casts_new
order by total_apperance desc
limit 10;

/*
15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/
select 
	category,
    count(*) as content_count
from
(
	select
		case
			when  description like '%kill%' or description like '%violence%' then 'Bad'
			else 'Good'
		end as category
	from netflix
) as categorized_content
group by category;