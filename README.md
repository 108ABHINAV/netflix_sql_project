# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/108ABHINAV/netflix_sql_project/blob/main/logo.png)

## 📌 Overview

I’ve always been curious about what Netflix really offers — Do they have more movies or TV shows? Which countries produce the most content? What kind of genres dominate the platform?
So I decided to explore the Netflix dataset using SQL. With a series of analytical queries, I tried to answer real business-style questions, uncover trends, and get a clearer picture of Netflix content.
This project helped me extract insights and strengthen my SQL skills through hands-on analysis.

---

## 🎯 Objectives

The purpose of this project was to dig into the Netflix Movies & TV Shows dataset and uncover meaningful insights that could answer real analytical questions. Throughout the project, my focus was to:

* Understand the distribution of Movies vs TV Shows
* Identify the most common content ratings
* Analyse content based on release year, duration, and geography
* Explore genres and category-wise distribution
* Track recently added content and long-duration titles
* Extract insights related to actors/directors using text parsing & JSON functions
* Categorize content using keyword-based filters
* Build reusable SQL queries for real business use cases

Dataset URL:
🔗 [https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

---

## 🗂 Dataset Schema

```sql
CREATE TABLE netflix (
    show_id        VARCHAR(10),
    type_name      VARCHAR(20),      -- Movie / TV Show
    title          VARCHAR(250),
    director       VARCHAR(500),
    casts          VARCHAR(2000),
    country        VARCHAR(500),
    date_added     DATE,
    release_year   INT,
    rating         VARCHAR(20),
    duration       VARCHAR(20),      -- Movie runtime OR number of seasons
    listed_in      VARCHAR(500),     -- Genre categories
    description    VARCHAR(1000)
);
```

---

## 🔍 Business Problems, SQL Queries & Insights

### **1. Count Movies vs TV Shows**

```sql
SELECT type_name, COUNT(*) AS total_content
FROM netflix 
GROUP BY type_name;
```

**Insight:** Shows which type dominates Netflix's content library.

---

### **2. Most Common Rating for Each Type**

```sql
SELECT type_name, rating
FROM (
	SELECT type_name, rating, COUNT(*),
           RANK() OVER (PARTITION BY type_name ORDER BY COUNT(*) DESC) AS ranking
	FROM netflix
	GROUP BY type_name, rating
) AS t1
WHERE ranking = 1;
```

**Insight:** Helps identify audience maturity and viewer targeting patterns.

---

### **3. Movies Released in 2020**

```sql
SELECT title AS Movie_Name
FROM netflix
WHERE type_name = 'Movie' AND release_year = 2020;
```

**Insight:** Useful for year-wise content trend studies.

---

### **4. Top 5 Countries with Most Content**

```sql
SELECT DISTINCT TRIM(country_new), COUNT(*) AS total_content
FROM (
	SELECT show_id, jt.country_new
	FROM netflix n,
	JSON_TABLE(CONCAT('["',REPLACE(n.country,',','","'),'"]'),
               '$[*]' COLUMNS (country_new VARCHAR(50) PATH '$')) jt
) t
WHERE country_new IS NOT NULL AND country_new!=''
GROUP BY country_new
ORDER BY total_content DESC
LIMIT 5;
```

**Insight:** Highlights major content-producing regions on Netflix.

---

### **5. Longest Movie**

```sql
SELECT title, duration
FROM netflix
WHERE type_name='Movie'
ORDER BY SUBSTRING(duration,1,INSTR(duration,' ')-1) DESC
LIMIT 1;
```

**Insight:** Interesting to locate long-format cinematic productions.

---

### **6. Content Added in the Last 5 Years**

```sql
SELECT date_added
FROM netflix
WHERE date_added < DATE_SUB(CURDATE(), INTERVAL 5 YEAR);
```

**Insight:** Shows recent additions and publishing frequency.

---

### **7. Content by Director ‘Rajiv Chilaka’**

```sql
SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';
```

**Insight:** Helps build director-wise content listings.

---

### **8. TV Shows with More Than 5 Seasons**

```sql
SELECT title, duration 
FROM netflix
WHERE type_name='TV Show' 
  AND SUBSTR(duration,1,INSTR(duration,' ')-1) > 5;
```

**Insight:** Shows long-running series with strong engagement.

---

### **9. Genre-wise Content Count**

```sql
SELECT DISTINCT TRIM(genre), COUNT(*) AS total_count
FROM (
	SELECT show_id, jt.genre
	FROM netflix n,
	JSON_TABLE(CONCAT('["',REPLACE(n.listed_in,',','","'),'"]'),
               '$[*]' COLUMNS (genre VARCHAR(50) PATH '$')) jt
) t
GROUP BY genre
ORDER BY total_count DESC;
```

**Insight:** Useful for understanding content diversity and recommendation scope.

---

### **10. Top 5 Years with Most Indian Releases**

```sql
SELECT country, release_year, COUNT(show_id) AS total_release,
       ROUND(COUNT(show_id)/(SELECT COUNT(show_id) FROM netflix WHERE country LIKE 'india')*100,2) AS avg_release
FROM netflix
WHERE country LIKE 'india'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;
```

**Insight:** Tracks growth trends of Indian content over time.

---

### **11. List All Documentaries**

```sql
SELECT title
FROM netflix
WHERE type_name='Movie' AND listed_in LIKE '%documentaries%';
```

**Insight:** Pulls all informational and non-fiction cinema.

---

### **12. Content Without Director Field**

```sql
SELECT *
FROM netflix
WHERE director IS NULL OR director='';
```

**Insight:** Useful for missing metadata audits.

---

### **13. Salman Khan Movies Added in Last 10 Years**

```sql
SELECT COUNT(*) AS total_movies
FROM netflix
WHERE casts LIKE '%salman khan%' 
  AND date_added < DATE_SUB(CURDATE(),INTERVAL 10 YEAR);
```

**Insight:** Shows presence and demand of Bollywood actors on the platform.

---

### **14. Top 10 Most Featured Actors in Indian Titles**

```sql
SELECT DISTINCT TRIM(casts_new) AS actors, COUNT(*) AS total_appearance
FROM (
	SELECT show_id, casts_new, country
	FROM netflix n,
	JSON_TABLE(CONCAT('["',REPLACE(n.casts,',','","'),'"]'),
               '$[*]' COLUMNS (casts_new VARCHAR(50) PATH '$')) jt
) t
WHERE country LIKE 'india' AND casts_new!=''
GROUP BY casts_new
ORDER BY total_appearance DESC
LIMIT 10;
```

**Insight:** Helps identify high-demand actors in Indian content.

---

### **15. Categorize Content by Keywords**

```sql
SELECT category, COUNT(*) AS content_count
FROM (
	SELECT CASE
		    WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
		    ELSE 'Good'
		  END AS category
	FROM netflix
) categorized_content
GROUP BY category;
```

**Insight:** Useful for content sensitivity detection and moderation.

---

## 📊 Findings & Conclusion

* Netflix hosts a wide variety of content with Movies and TV Shows distributed across multiple genres.
* Ratings reveal the type of audience Netflix mostly targets.
* Certain countries dominate content production, while others contribute niche content.
* Keyword-based categorization helps identify violent vs non-violent theme content.
* Analysis gives a clear view of Netflix’s catalog patterns, useful for business or data-driven decisions.

---

## ✍ Author — **ABHINAV TYAGI**

If you found this project helpful, connect with me here:

💼 **LinkedIn:** [(https://www.linkedin.com/in/abhinav-tyagi-649779282/)]

---

### ⭐ If you like this project, please give a star to the repository!

