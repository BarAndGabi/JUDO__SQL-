use judo;
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

select * from battles where judge_id=204;


-- list of judokas fouls
select teammates.name,count(fouls.judokas_id) as fouls
from teammates,fouls
where fouls.judokas_id=teammates.id
group by teammates.id;

-- list of judge 204 most judged category

SELECT judge.name,battles.category,count(battles.category) as battles_count
FROM judge
RIGHT JOIN battles ON battles.judge_id=judge.id
WHERE battles.judge_id='207'
GROUP BY battles.category
ORDER BY  count(battles.category) DESC LIMIT 1;

-- every category winner of the comp

SELECT teammates.name,category,count(`battle results`.winner) as result
FROM judokas,`battle results`,teammates
WHERE judokas.id=`battle results`.winner and  judokas.id=teammates.id
GROUP BY judokas.id,judokas.category
ORDER BY  result DESC 
LIMIT 4;

-- get list of all judokas precentage of victory

select  teammates.name,judokas.wins/judokas.`game played` as win_ratio
from teammates,judokas
where teammates.id = judokas.id;


