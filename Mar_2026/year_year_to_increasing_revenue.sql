create table company_revenue 
(
company varchar(100),
year int,
revenue int
);

insert into company_revenue values 
('ABC1',2000,100),('ABC1',2001,110),('ABC1',2002,120),('ABC2',2000,100),('ABC2',2001,90),('ABC2',2002,120)
,('ABC3',2000,500),('ABC3',2001,400),('ABC3',2002,600),('ABC3',2003,800);

select * from company_revenue;

with year_year_ration as (
select 
    company,
    year,
    revenue,
    lag(revenue) over(partition by company order by year) as previous_year
from
    company_revenue),
find_streak as (
    select  
    *,
    case when previous_year is null then 0
    when revenue > previous_year then 1
    else -1 end as steak
    from
    year_year_ration
)
select 
    company
from 
    find_streak
group by company

having min(revenue) != -1
    

