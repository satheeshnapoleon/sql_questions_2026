CREATE TABLE airports (
    port_code VARCHAR(10) PRIMARY KEY,
    city_name VARCHAR(100)
);

CREATE TABLE flights (
    flight_id varchar (10),
    start_port VARCHAR(10),
    end_port VARCHAR(10),
    start_time datetime,
    end_time datetime
);

INSERT INTO airports (port_code, city_name) VALUES
('JFK', 'New York'),
('LGA', 'New York'),
('EWR', 'New York'),
('LAX', 'Los Angeles'),
('ORD', 'Chicago'),
('SFO', 'San Francisco'),
('HND', 'Tokyo'),
('NRT', 'Tokyo'),
('KIX', 'Osaka');

INSERT INTO flights VALUES
(1, 'JFK', 'HND', '2025-06-15 06:00', '2025-06-15 18:00'),
(2, 'JFK', 'LAX', '2025-06-15 07:00', '2025-06-15 10:00'),
(3, 'LAX', 'NRT', '2025-06-15 10:00', '2025-06-15 22:00'),
(4, 'JFK', 'LAX', '2025-06-15 08:00', '2025-06-15 11:00'),
(5, 'LAX', 'KIX', '2025-06-15 11:30', '2025-06-15 22:00'),
(6, 'LGA', 'ORD', '2025-06-15 09:00', '2025-06-15 12:00'),
(7, 'ORD', 'HND', '2025-06-15 11:30', '2025-06-15 23:30'),
(8, 'EWR', 'SFO', '2025-06-15 09:00', '2025-06-15 12:00'),
(9, 'LAX', 'HND', '2025-06-15 13:00', '2025-06-15 23:00'),
(10, 'KIX', 'NRT', '2025-06-15 08:00', '2025-06-15 10:00');




with get_all_routes as (
select 
f.flight_id,a.city_name as start_port,
b.city_name as end_port,
f.start_time, f.end_time
from flights f
left join airports a
on f.start_port = a.port_code
left join airports b
on f.end_port = b.port_code),
find_all_possible_routest as (
    select * 
    from 
    get_all_routes
    where end_port = 'Tokyo'
    union
    select * from 
    get_all_routes where start_port in (select start_port from get_all_routes where end_port = 'Tokyo')
),
get_middle_port as (
    select 
        f.flight_id,
        f.start_port,
      
        s.start_port as middle_port,
        s.end_port as end_port,
        f.start_time as start_time,
        f.end_time as end_time,
        s.flight_id as middle_fligt_id,
        s.start_time as middle_flight_start_time,
        s.end_time as middle_flight_end_time

      from
     find_all_possible_routest f
     inner join find_all_possible_routest s
     on f.end_port = s.start_port
     where s.end_port = 'Tokyo'
     union 
     select f.flight_id,
     f.start_port,
     null as middle_port,
     f.end_port,
     f.start_time,
     f.end_time,
     null,
     null,
     null
   
     from get_all_routes f
     where f.end_port = 'Tokyo'

)
select 
    start_port as start_city , 
    middle_port as middle_city, 
    end_port as end_city, 
    case 
        when middle_city is not null then concat(flight_id,',',coalesce(middle_fligt_id,''))
        else flight_id end as flights,
    start_time as start_time,
    coalesce(middle_flight_end_time, end_time) as end_time,
    datediff('seconds', start_time, end_time) as total_travel_time_minutes
 from get_middle_port
where start_port = 'New York' and (end_time <= middle_flight_start_time or middle_port is null);