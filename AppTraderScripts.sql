SELECT
	name,
	asa.price,
--	psa.price,
	asa.review_count::numeric,
	psa.review_count::numeric,
	asa.rating,
	psa.rating,
	asa.content_rating,
	psa.content_rating
FROM app_store_apps AS asa
	INNER JOIN play_store_apps AS psa
	USING(name)
WHERE asa.price <= 1.0
AND asa.review_count::numeric > '300000'
AND psa.review_count::numeric > '300000'
AND asa.content_rating = '4+'
AND psa.content_rating = 'Everyone'
ORDER BY asa.price DESC;


