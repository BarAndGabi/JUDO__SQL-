
-- get all male judokas from category heavy and old order by win count 1
select  teammates.id,name,team,weight,gender,`coach id`,age,category,`is injured`,wins,`game played`
from teammates 
inner join judokas
on judokas.id=teammates.id and category ="mho"
order by judokas.wins;

-- how many games each judge judged 2 
select judge.name, count(judge_id) as game_jugdged
from battles,judge
where judge.id=battles.judge_id
group by judge.id;

-- how many judokas from each category. 3
select categorys.id, count(judokas.id) as amount
from categorys,judokas
where judokas.category=categorys.id
group by categorys.id;

-- list of shuky(207) battles 4

select * from battles where judge_id=207;


-- list of judokas fouls 5
select teammates.name,count(fouls.judokas_id) as fouls
from teammates,fouls
where fouls.judokas_id=teammates.id
group by teammates.id;

-- list of judge 207 most judged category 6

SELECT judge.name,battles.category,count(battles.category) as battles_count
FROM judge
RIGHT JOIN battles ON battles.judge_id=judge.id
WHERE battles.judge_id='207'
GROUP BY battles.category
ORDER BY  count(battles.category) DESC LIMIT 1;
-- every category winner of the comp 7
SELECT teammates.name,categorys.id,count(`battle results`.winner) as 'Win Count'
FROM categorys,teammates,`battle results`
WHERE teammates.id=give_category(categorys.id) and give_category(categorys.id)=`battle results`.winner
GROUP BY teammates.id,categorys.id;

-- Highest sponsor payer in the Olympics 8
SELECT teams_name as 'Team',sponsers.name as 'Sponsors name' ,max(money_contribute) as 'Highest payer'
FROM teams_has_sponsers,teams,sponsers
WHERE teams_has_sponsers.sponsers_id=sponsers.id
GROUP BY teams_name,sponsers.id LIMIT 1;

-- All the judokas that won with 'ippon'  9
SELECT `battle results`.id,teammates.name,judge.name
FROM `battle results`,teammates,judge
WHERE `battle results`.`win type`='ippon' and `battle results`.winner=teammates.id
GROUP BY teammates.name ,judge.name,`battle results`.id;

-- How many ippons did lil wayne do 10
SELECT teammates.name,count(`battle results`.winner)
FROM `battle results`,teammates
WHERE `battle results`.`win type`='ippon' and teammates.name='lil wayne' and `battle results`.winner=(SELECT teammates.id as lil_Wayne
FROM teammates
WHERE teammates.name="lil wayne");

-- Average age in each category 11
SELECT AVG_Every_Category(categorys.id),categorys.id
FROM categorys
GROUP BY categorys.id;

-- Average of the USA team 12
SELECT teammates.name,AVG(judokas.age)
FROM judokas,teammates
WHERE judokas.id=teammates.id and teammates.team='usa'
GROUP BY teammates.id;

-- Team with the most fouls 13
SELECT teams.name,sum_of_fouls(teams.name) as 'fouls commited'
FROM teams
ORDER BY 'fouls commited' DESC LIMIT 1;
-- How much money was spend for this Olympic's 14
SELECT SUM(money_contribute)
FROM teams_has_sponsers;

-- get the amount of fouls each judge gave 15
select judo.judge.name,judge.id, count(fouls.battles_judge_id) as fouls
from judge,fouls
where fouls.battles_judge_id=judge.id
group by judge.id
order by fouls desc;

-- Mexico battle list
SELECT *
FROM battles
WHERE `judoka 1 id`  IN ( SELECT teammates.id 
FROM teammates
WHERE teammates.team='mexico') or `juduka 2 id` in (SELECT teammates.id 
FROM teammates
WHERE teammates.team='mexico');

-- wins of 2023-08-06
SELECT  teammates.id,teammates.name,count(winner) as win_count
from teammates,`battle results`,battles
WHERE battles.date='2023-08-06' and battles.id=`battle results`.id and winner=teammates.id
group by teammates.id
order by win_count desc;