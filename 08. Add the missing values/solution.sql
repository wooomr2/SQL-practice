-- Solution 1 - Using Window function
with cte as 
	(select *
	, sum(case when job_role is null then 0 else 1 end) over(order by row_id) as segment
	from job_skills)
select row_id
, first_value(job_role) over(partition by segment order by row_id) as job_role
, skills
from cte;



-- Solution 2 - WITHOUT Using Window function
/** recursive 기본 문법
  wirh recursive cte as
  (
    base query
    union
    recursive query with termination condition
  )
  select *
  from cte;
*/
with recursive cte as
(
	select row_id, job_role, skills
	from job_skills
	where row_id = 1
	union
	select js.row_id, coalesce(js.job_role, cte.job_role) as job_role, js.skills
	from cte
	join job_skills as js
	on js.row_id = cte.row_id+1
)
select * 
from cte

