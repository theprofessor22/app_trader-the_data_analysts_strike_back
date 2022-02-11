-- WITH rating as 
-- (SELECT name, asa.rating as apprate, psa.rating as psarate
-- FROM app_store_apps as asa INNER JOIN play_store_apps as psa USING(name)
-- WHERE asa.rating > 4.0 and psa.rating > 4.0)

-- SELECT 
-- FROM app_store_apps as apple INNER JOIN rating ON apple.name = rating.name
-- INNER JOIN play_store_apps as play ON apple.name = play.name
-- WHERE 

-- SELECT DISTINCT asa.name as appname, asa.primary_genre as appgenre, psa.genres as psagenre
-- FROM app_store_apps as asa INNER JOIN play_store_apps as psa USING(name)
-- WHERE asa.primary_genre NOT ILIKE '%social networking%' AND asa.name LIKE '%pi%'
-- ORDER BY appgenre
SELECT name, price, review_count::numeric, primary_genre, content_rating
FROM (SELECT *
	FROM app_store_apps
	WHERE content_rating < '4+' AND (review_count::numeric > 50000) AND (primary_genre ILIKE '%Education%' OR primary_genre ILIKE '%Food & Drink%' OR primary_genre ILIKE '%Games%')
	ORDER BY primary_genre) as selectgenre
ORDER BY review_count::numeric DESC;
