create table assessments
(
id int,
experience int,
sql int,
algo int,
bug_fixing int
);
insert into assessments values 
(1,3,100,null,50),
(2,5,null,100,100),
(3,1,100,100,100),
(4,5,100,50,null),
(5,5,100,100,100);


with calculate_is_perfect as (select
    id,
    experience,
    case 
    when coalesce(sql,100) < 100 then false
    when coalesce(algo,100) < 100 then false
    when coalesce(bug_fixing,100) < 100 then false
    else true end as  is_perfect
from
assessments)
select 
    count(*) as total_student,
    experience,
    sum(case when is_perfect = true then 1 else 0 end) as total_perfect
from 
   calculate_is_perfect
group by experience





