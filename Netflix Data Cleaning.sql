-- Checking for duplicates in the unique Id coloumn (show_id)
-- None found
SELECT 
show_id,
Count(*)
FROM netflix_titles
GROUP BY show_id
ORDER BY show_id desc;

-- Convert empty values to null values
UPDATE netflix_titles SET 
    Type = NULLIF(Type, ''),
    title = NULLIF(title, ''),
    director = NULLIF(director, ''),
    cast = NULLIF(cast, ''),
    country = NULLIF(country, ''),
    date_added = NULLIF(date_added, ''),
    release_year = NULLIF(release_year, ''),
    rating = NULLIF(rating, ''),
    duration = NULLIF(duration, ''),
    listed_in = NULLIF(listed_in, ''),
    description = NULLIF(description, '');
    
    -- Check for Null values across columns
    -- Results are - director_nulls 39, cast_nulls 11, country_nulls 41
    SELECT 
    COUNT(*) AS total_rows, 
    SUM(CASE WHEN show_id IS NULL THEN 1 ELSE 0 END) AS show_id_nulls, 
    SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) AS type_nulls,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
    SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS director_nulls,
    SUM(CASE WHEN cast IS NULL THEN 1 ELSE 0 END) AS cast_nulls,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
    SUM(CASE WHEN date_added IS NULL THEN 1 ELSE 0 END) AS date_added_nulls,
    SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) AS release_year_nulls,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS rating_nulls,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
    SUM(CASE WHEN listed_in IS NULL THEN 1 ELSE 0 END) AS listed_in_nulls,
    SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) AS description_nulls
FROM netflix_titles;

-- Query for rows with null values
SELECT *
FROM netflix_titles
WHERE director IS NULL 
OR cast IS NULL 
OR country IS NULL;

-- Update date_added column to compact format
UPDATE netflix_titles
SET date_added = STR_TO_DATE(date_added, '%M %e, %Y')
WHERE date_added IS NOT NULL;

-- Use the trim function to clean up trailing spaces
UPDATE netflix_titles 
SET 
    type = TRIM(type),
    title = TRIM(title),
    director = TRIM(director),
    cast = TRIM(cast),
    country = TRIM(country),
    date_added = TRIM(date_added),
    release_year = TRIM(release_year),
    rating = TRIM(rating),
    duration = TRIM(duration),
    listed_in = TRIM(listed_in),
    description = TRIM(description);
    
-- Split the country values keeping only the first country if any
-- Use case scenerio as geogrphical representation of netflix_titles
SELECT 
	show_id,
    type,
    release_year,
    rating,
    SUBSTRING_INDEX(country, ',', 1) AS Country_updated
FROM netflix_titles;
    
-- Optionaly the table can be updated
UPDATE netflix_titles
SET country = TRIM(SUBSTRING_INDEX(country, ',', 1))
WHERE country LIKE '%,%';

-- Find matching records across databases in order to populate some null values
SELECT nt.show_id, nt.title, nt.director, nt.cast, nt.country
FROM netflix_titles nt
JOIN netflix_data.netflix1 n1 ON nt.show_id = n1.show_id;

-- Update Null values
-- 37 changes recorded
UPDATE netflix_titles nt
JOIN netflix_data.netflix1 n1 ON nt.show_id = n1.show_id
SET nt.director = n1.director, nt.country = n1.country
WHERE nt.director IS NULL OR nt.country IS NULL