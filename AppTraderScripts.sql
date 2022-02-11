--main

WITH ms_1 AS
					(
					SELECT 
						name,
						asa.review_count::numeric AS as_review_count,
						asa.content_rating,
						asa.price::numeric,
						ROUND(ROUND(asa.rating/5,1)*5,1) AS asa_new_rating,
						ROUND(ROUND(ROUND(asa.rating/5,1)*5,1)/0.5 + 1, 0) as as_lifespan,
						psa.review_count::numeric AS ps_review_count,
						psa.content_rating,
						TRIM('$' FROM psa.price) AS trimprice,
						ROUND(ROUND(psa.rating/5,1)*5,1) AS psa_new_rating,
						ROUND(ROUND(ROUND(psa.rating/5,1)*5,1)/0.5 + 1, 0) as ps_lifespan,
						asa.primary_genre
					FROM app_store_apps AS asa
						INNER JOIN play_store_apps AS psa
						USING(name) 
					WHERE psa.rating IS NOT NULL
						AND asa.review_count::numeric BETWEEN '8000' AND '5000000' 
						AND psa.review_count::numeric BETWEEN '5000' AND '1500000'
						AND asa.rating IS NOT NULL
					),					

	ms_2 AS		
					(
					SELECT 
						*,
						GREATEST(price::numeric*10000, 10000) as as_cost_to_buy,
						GREATEST(trimprice::numeric*10000, 10000) as ps_cost_to_buy
					FROM ms_1
					),

	ms_3 AS			
					(
					SELECT
						*,
						ROUND((as_lifespan*12*4500) - as_cost_to_buy, 0) as as_expected_profit,
						ROUND((ps_lifespan*12*4500) - ps_cost_to_buy, 0) as ps_expected_profit
					FROM ms_2
					)

SELECT *
FROM ms_3
ORDER BY as_expected_profit DESC;