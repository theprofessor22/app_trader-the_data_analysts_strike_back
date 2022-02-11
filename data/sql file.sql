select name, app_store_apps.rating as app_rating, play_store_apps.rating as play_rating, app_store_apps.content_rating, app_store_apps.primary_genre
from app_store_apps inner join play_store_apps using(name)
group by name, app_store_apps.rating, play_store_apps.rating, app_store_apps.content_rating, app_store_apps.primary_genre
order by name;

select distinct count(*) from app_store_apps inner join play_store_apps using(name);

select name, review_count::numeric, price
from app_store_apps
where review_count::numeric > 50000 and price = 0.00
order by review_count desc;

select distinct name, primary_genre
from play_store_apps
inner join app_store_apps using(name)
order by name;

select trim('$' from price) as trimprice
from play_store_apps
order by price;

with price_fix as (
                   select distinct name, trim('$' from price) as trimprice, round(round(rating/5,1)*5,1) as new_rating, review_count,
                                   round(round(round(rating/5,1)*5,1)/0.5 + 1, 0) as lifespan_years
                   from play_store_apps
                   where review_count >= 50000
                   group by name, play_store_apps.price, play_store_apps.rating, play_store_apps.review_count
                   order by review_count desc
                  )
select psa.name, pf.trimprice::numeric, psa.rating, pf.new_rating, psa.review_count,
       greatest(trimprice::numeric*10000, 10000) as cost_to_buy,
       round((pf.lifespan_years*12*4000/2) - 10000, 0) as expected_profit
from play_store_apps as psa inner join price_fix as pf on psa.name = pf.name
group by trimprice, psa.rating, psa.review_count, psa.name, pf.new_rating, pf.lifespan_years
order by trimprice desc;


with filtered_play as (with price_fix as (
                                          select name, trim('$' from price) as trimprice, round(round(rating/5,1)*5,1) as new_rating, review_count,
                                          round(round(round(rating/5,1)*5,1)/0.5 + 1, 0) as lifespan_years
                                          from play_store_apps
                                          where review_count >= 50000
                                          group by name, play_store_apps.price, play_store_apps.rating, play_store_apps.review_count
                                          order by review_count desc
                                         )
                       select psa.name, pf.trimprice::numeric, psa.rating, pf.new_rating, psa.review_count,
                       greatest(trimprice::numeric*10000, 10000) as cost_to_buy,
                       round((pf.lifespan_years*12*2000/2) - 10000, 0) as expected_profit
                       from play_store_apps as psa inner join price_fix as pf on psa.name = pf.name
                       group by trimprice, psa.rating, psa.review_count, psa.name, pf.new_rating, pf.lifespan_years
                       order by trimprice desc)
select filtered_play.name, trimprice, filtered_play.expected_profit
from filtered_play
group by name, expected_profit, trimprice
order by expected_profit desc;

select distinct primary_genre from app_store_apps order by primary_genre;

select name, primary_genre, review_count::numeric
from app_store_apps
where review_count::numeric > 50000 and (primary_genre ilike 'games' or primary_genre ilike 'education')
order by review_count;







with price_fix as (
                   select name, trim('$' from price) as trimprice
                   from play_store_apps
                   order by price
                         )
select pf.trimprice::numeric
from play_store_apps as psa inner join price_fix as pf on psa.name = pf.name





select name, trim('$' from price) as trimprice, genres
from play_store_apps
order by price












