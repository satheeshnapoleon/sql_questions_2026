CREATE TABLE matches (
    match_id INT PRIMARY KEY,
    winning_team_id INT,
    losing_team_id INT,
    goals_won INT
);
INSERT INTO matches (match_id, winning_team_id, losing_team_id, goals_won) VALUES
(1, 1001, 1007, 1),
(2, 1007, 1001, 2),
(3, 1006, 1003, 3),
(4, 1001, 1003, 1),
(5, 1007, 1001, 1),
(6, 1006, 1003, 2),
(7, 1006, 1001, 3),
(8, 1007, 1003, 5),
(9, 1001, 1003, 1),
(10, 1007, 1006, 2),
(11, 1006, 1003, 3),
(12, 1001, 1003, 4),
(13, 1001, 1006, 2),
(14, 1007, 1001, 4),
(15, 1006, 1007, 3),
(16, 1001, 1003, 3),
(17, 1001, 1007, 3),
(18, 1006, 1007, 2),
(19, 1003, 1001, 1);

insert into matches values
(20, 1001, 1007, 3),
(21, 1001, 1003, 3);
;


select * from matches;

with total_goals_scored as (
    select 
        sum(goals_won) as total_goal_scored,
        winning_team_id
    from 
        matches
    group by winning_team_id
),
total_goals_lost as (
    select 
        sum(goals_won) as total_goal_lost,
        losing_team_id
    from 
        matches 
    group by losing_team_id
)
select
    w.winning_team_id,
    total_goal_scored,
    total_goal_lost,
    total_goal_scored - total_goal_lost as total_goal_gain
from 
    total_goals_scored w 
full outer join total_goals_losed l 
on w.winning_team_id = l.losing_team_id
order by total_goal_gain desc 


