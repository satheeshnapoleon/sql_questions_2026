CREATE TABLE stock (
    supplier_id INT,
    product_id INT,
    stock_quantity INT,
    record_date DATE
);

-- Insert the data
INSERT INTO stock (supplier_id, product_id, stock_quantity, record_date)
VALUES
    (1, 1, 60, '2022-01-01'),
    (1, 1, 40, '2022-01-02'),
    (1, 1, 35, '2022-01-03'),
    (1, 1, 45, '2022-01-04'),
 (1, 1, 51, '2022-01-06'),
 (1, 1, 55, '2022-01-09'),
 (1, 1, 25, '2022-01-10'),
    (1, 1, 48, '2022-01-11'),
 (1, 1, 45, '2022-01-15'),
    (1, 1, 38, '2022-01-16'),
    (1, 2, 45, '2022-01-08'),
    (1, 2, 40, '2022-01-09'),
    (2, 1, 45, '2022-01-06'),
    (2, 1, 55, '2022-01-07'),
    (2, 2, 45, '2022-01-08'),
 (2, 2, 48, '2022-01-09'),
    (2, 2, 35, '2022-01-10'),
 (2, 2, 52, '2022-01-15'),
    (2, 2, 23, '2022-01-16');

select * from stock;

with first_cte  as ( 
    select 
        *,
        coalesce(lag(record_date) over(partition by supplier_id,product_id order by record_date),record_date) as previous_date,
        datediff('day',previous_date,record_date) as day_diff,
        coalesce(lag(stock_quantity) over(partition by supplier_id,product_id order by record_date),stock_quantity)  as previous_stock
     
        
    from 
        stock
    where stock_quantity < 50
),
second_cte as (
    select 
        *,
        case when day_diff <= 1 then 0 else 1 end as group_flag
    from    
        first_cte
),
third_cte as (
    select 
        *,
        sum(group_flag) over(partition by supplier_id,product_id order by record_date) as running_group 
    from 
        second_cte
),
fourth_cte as (
select *, sum(group_flag) over(partition by supplier_id,product_id order by record_date rows between unbounded preceding and current row) as run_sum
from third_cte )
select
    count(*) as total_records,
    supplier_id,
    product_id,
    min(record_date)
from 
    fourth_cte 
group by supplier_id,product_id,run_sum
having total_records = 2 or total_records = 3;