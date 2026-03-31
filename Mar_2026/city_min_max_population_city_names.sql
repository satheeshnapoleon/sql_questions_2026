CREATE TABLE city_population (
    state VARCHAR(50),
    city VARCHAR(50),
    population INT
);

-- Insert the data
INSERT INTO city_population (state, city, population) VALUES ('haryana', 'ambala', 100);
INSERT INTO city_population (state, city, population) VALUES ('haryana', 'panipat', 200);
INSERT INTO city_population (state, city, population) VALUES ('haryana', 'gurgaon', 300);
INSERT INTO city_population (state, city, population) VALUES ('punjab', 'amritsar', 150);
INSERT INTO city_population (state, city, population) VALUES ('punjab', 'ludhiana', 400);
INSERT INTO city_population (state, city, population) VALUES ('punjab', 'jalandhar', 250);
INSERT INTO city_population (state, city, population) VALUES ('maharashtra', 'mumbai', 1000);
INSERT INTO city_population (state, city, population) VALUES ('maharashtra', 'pune', 600);
INSERT INTO city_population (state, city, population) VALUES ('maharashtra', 'nagpur', 300);
INSERT INTO city_population (state, city, population) VALUES ('karnataka', 'bangalore', 900);
INSERT INTO city_population (state, city, population) VALUES ('karnataka', 'mysore', 400);
INSERT INTO city_population (state, city, population) VALUES ('karnataka', 'mangalore', 200);


with get_min_max_city as (
    select 
        state,
        min(population) as min_population,
        max(population) as max_population 
    from 
        city_population
    group by 
        state
)
select 
    o.state,
    max(case when o.population = s.min_population then city end) as min_population_city, 
    max(case when o.population = s.max_population then city end) as max_population_city
from 
   city_population o
left join get_min_max_city s
on o.state = s.state
group by o.state