create table call_start_logs
(
phone_number varchar(10),
start_time datetime
);
insert into call_start_logs values
('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00');

insert into call_start_logs values ('PN1','2022-01-01 15:00:00');
insert into call_end_logs values ('PN1','2022-01-01 15:45:00');
create table call_end_logs
(
phone_number varchar(10),
end_time datetime
);
insert into call_end_logs values
('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00')
;

select * from call_start_logs;
select * from call_end_logs;


with find_next_start_time  as (
    select 
    phone_number,
    start_time,
    lead(start_time) over(partition by phone_number order by start_time) as next_call_start_time
    from 
    call_start_logs
)
select s.phone_number , s.start_time ,e.end_time, datediff('minutes',s.start_time,e.end_time) as time_taken
from find_next_start_time s
inner join call_end_logs e 
on s.phone_number = e.phone_number and ((s.start_time < e.end_time and e.end_time < s.next_call_start_time) or (s.next_call_start_time is null and s.next_call_start_time is null and s.start_time < e.end_time))
order by s.phone_number