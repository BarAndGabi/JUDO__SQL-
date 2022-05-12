
-- get all male judokas from category heavy and old order by win count
select  teammates.id,name,team,weight,gender,`coach id`,age,category,`is injured`,wins,`game played`
from teammates 
inner join judokas
on judokas.id=teammates.id and category ="mho"
order by judokas.wins;

-- how many games each judge judged
select judge.name, count(judge_id) as game_jugdged
from battles,judge
where judge.id=battles.judge_id
group by judge.id;

-- how many judokas from each category.
select categorys.id, count(judokas.id) as amount
from categorys,judokas
where judokas.category=categorys.id
group by categorys.id;

-- list of shuky(207) battles

select * from battles where judge_id=207;


-- list of judokas fouls
select teammates.name,count(fouls.judokas_id) as fouls
from teammates,fouls
where fouls.judokas_id=teammates.id
group by teammates.id;

-- list of judge 207 most judged category

SELECT judge.name,battles.category,count(battles.category) as battles_count
FROM judge
RIGHT JOIN battles ON battles.judge_id=judge.id
WHERE battles.judge_id='207'
GROUP BY battles.category
ORDER BY  count(battles.category) DESC LIMIT 1;

-- every category winner of the comp
CREATE FUNCTION give_category(category_id varchar(3))
RETURNS INT  deterministic
RETURN (SELECT judokas.id
FROM judokas,`battle results`,teammates
WHERE judokas.id=`battle results`.winner and  judokas.id=teammates.id and category=category_id
GROUP BY judokas.id,judokas.category
ORDER BY  count(`battle results`.winner) DESC,category DESC LIMIT 1);
 

SELECT teammates.name,categorys.id,count(`battle results`.winner) as 'Win Count'
FROM categorys,teammates,`battle results`
WHERE teammates.id=give_category(categorys.id) and give_category(categorys.id)=`battle results`.winner
GROUP BY teammates.id,categorys.id;
-- Highest sponsor payer in the Olympics
SELECT teams_name as 'Team',sponsers.name as 'Sponsors name' ,max(money_contribute) as 'Highest payer'
FROM teams_has_sponsers,teams,sponsers
WHERE teams_has_sponsers.sponsers_id=sponsers.id
GROUP BY teams_name,sponsers.id LIMIT 1;

-- All the judokas that won with 'ippon' 
SELECT `battle results`.id,teammates.name,judge.name
FROM `battle results`,teammates,judge
WHERE `battle results`.`win type`='ippon' and `battle results`.winner=teammates.id
GROUP BY teammates.name ,judge.name,`battle results`.id;

-- How many ippons did lil wayne do
SELECT teammates.name,count(`battle results`.winner)
FROM `battle results`,teammates
WHERE `battle results`.`win type`='ippon' and teammates.name='lil wayne' and `battle results`.winner=(SELECT teammates.id as lil_Wayne
FROM teammates
WHERE teammates.name="lil wayne");

-- Average age in each category
SELECT AVG_Every_Category(categorys.id),categorys.id
FROM categorys
GROUP BY categorys.id;

-- Average of the USA team
SELECT teammates.name,AVG(judokas.age)
FROM judokas,teammates
WHERE judokas.id=teammates.id and teammates.team='usa'
GROUP BY teammates.id;

-- Team with the most fouls
SELECT teams.name,sum_of_fouls(teams.name) as 'fouls commited'
FROM teams
ORDER BY 'fouls commited' DESC LIMIT 1;
-- How much money was spend for this Olympic's
SELECT SUM(money_contribute)
FROM teams_has_sponsers;


