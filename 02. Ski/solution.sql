with 
cte_trail1 as 
(
	select t1.hut1 as start_hut, h1.name as start_hut_name, h1.altitude as start_hut_altitude, 
	       t1.hut2 as end_hut
	from mountain_huts h1
	join trails t1 ON t1.hut1 = h1.id
),

cte_trail2 as 
(
select t2.*, h2.name as end_hut_name, h2.altitude as end_hut_altitude,
       case when start_hut_altitude > h2.altitude then 1 else 0 end as altitude_flag
from cte_trail1 t2
join mountain_huts h2 ON t2.end_hut = h2.id
),

cte_final as
(
select 
  case when altitude_flag = 1 then start_hut else end_hut end as start_hut,
  case when altitude_flag = 1 then start_hut_name else end_hut_name end as start_hut_name,
  case when altitude_flag = 1 then end_hut else start_hut end as end_hut,
  case when altitude_flag = 1 then end_hut_name else start_hut_name end as end_hut_name
from cte_trail2
)

select c1.start_hut_name as startpt, c1.end_hut_name as middlept, c2.end_hut_name as endpt
from cte_final c1 
-- self-join
join cte_final c2 on c1.end_hut = c2.start_hut;


-- --------------------------------------------------------------------------------------------------
-- Solution 2

with cte as
(
	select h1.id as h1_id, h1.name as h1_name, h1.altitude as h1_altitude,
		   h2.id as h2_id, h2.name as h2_name, h2.altitude as h2_altitude,
		   case when h1.altitude > h2.altitude then 1 else 0 end as altitude_flag
	from trails t
	inner join mountain_huts h1 on t.hut1 = h1.id
	inner join mountain_huts h2 on t.hut2 = h2.id
),

cte_final as 
(
	select
		case when altitude_flag = 1 then h1_name else h2_name end as start_name,
		case when altitude_flag = 1 then h1_altitude else h2_altitude end as start_altitude,
		case when altitude_flag = 1 then h2_name else h1_name end as end_name,
		case when altitude_flag = 1 then h2_altitude else h1_altitude end as end_altitude
	from cte 
)

select c1.start_name as startpt, c1.end_name as middlept, c2.end_name as endpt 
from cte_final as c1
inner join cte_final as c2 on c1.end_altitude = c2.start_altitude