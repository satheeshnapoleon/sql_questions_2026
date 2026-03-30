//what learned in this chapter 

// dayofweek('date') it returns 1 to 7 
1 -> sunday
2 -> monday
    .
    .
    .
    .
    .
7 -> saturday

//find weeks between two days 
datediff('week',start_end, end_date) -> it returns if week is available it return int value for example if two week 




create table tickets
(
ticket_id varchar(10),
create_date date,
resolved_date date
);
delete from tickets;
insert into tickets values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');
create table holidays
(
holiday_date date
,reason varchar(100)
);
delete from holidays;
insert into holidays values
('2022-08-11','Rakhi'),('2022-08-15','Independence day');

select * from holidays;

select * from tickets;


with join_holiday_date as (
select t.*, h.reason, case when dayofweek(h.holiday_date) in (1,7) then 1 else 0 end as is_holiday_is_week
from tickets t
left join holidays h
on h.holiday_date between create_date and resolved_date and dayofweek(h.holiday_date) not in (1,7))
select ticket_id,create_date, resolved_date, (datediff('day', create_date , resolved_date) - (count(reason) + 2 * datediff('week',create_date,resolved_date))) as total_time_taken,
count(reason) as total_holidays
from
join_holiday_date
group by ticket_id,create_date,resolved_date