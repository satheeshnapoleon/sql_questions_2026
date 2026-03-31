create table employee 
(
emp_name varchar(10),
dep_id int,
salary int
);
delete from employee;
insert into employee values 
('Siva',1,30000),('Ravi',2,40000),('Prasad',1,50000),('Sai',2,20000)
insert into employee values ('satheesh',1,50000)
select * from employee;

with max_salary_each_department as (
    select 
    *,
    'max' as max_salary
    from 
    employee
    qualify  dense_rank() over(partition by dep_id order by salary desc) = 1
    union all
    select 
    *,
    'min' as min_salary
    from 
    employee
    qualify  dense_rank() over(partition by dep_id order by salary) = 1
)
select 
    dep_id,
    array_to_string(array_agg(case when max_salary = 'max' then emp_name end),',') as department_max_salary,
    array_to_string(array_agg(case when max_salary = 'min' then emp_name end),',') as department_max_salary
from 
max_salary_each_department
group by dep_id
order by dep_id;



w
