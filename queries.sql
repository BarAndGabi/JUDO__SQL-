
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
