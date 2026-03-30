CREATE TABLE emp_salary
(
    emp_id INT  NOT NULL,
    name VARCHAR(20)  NOT NULL,
    salary NVARCHAR(30),
    dept_id INTEGER
);


INSERT INTO emp_salary
(emp_id, name, salary, dept_id)
VALUES(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');

select * from emp_salary;


with first_cte as 
(select 
    *,
    dense_rank() over(partition by dept_id order by salary) as rnk
from
    emp_salary)
select 
* 
from 
first_cte 
where salary in (select salary from first_cte group by salary,dept_id,rnk having count(*) > 1) and dept_id = 11
order by dept_id;
