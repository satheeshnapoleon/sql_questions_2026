with first_cte as (
select 
    user_id,
    date_searched,
    case when contains(filter_room_types,'entire home') then 1 else 0 end as entire_home,
    case when contains(filter_room_types,'shared room') then 1 else 0 end as shared_room,
    case when contains(filter_room_types,'private room') then 1 else 0 end as private_room
from
    airbnb_searches
)
select 
sum(entire_home) as cnt,
'entire_home' as room_type
from 
first_cte
union all
select 
sum(shared_room) as cnt,
'shared_room' as room_type
from 
first_cte
union all
select
sum(private_room) as cnt,
'private room' as room_type
from 
first_cte