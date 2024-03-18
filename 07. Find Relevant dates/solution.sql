-- isodow: iso day of week (1(월)-7(일))


-- Solution in PostgreSQL
select product_id, day_indicator, dates
from (
	select * , extract('isodow' from dates) as dow
	, case when substring(day_indicator,extract('isodow' from dates)::int,1) = '1' 
				then 'Include' else 'Exlcude' end as flag
	from Day_Indicator) x
where flag='Include';




-- Solution in Microsoft SQL Server
select product_id, day_indicator, dates
from (
	select * 
	, case when substring(day_indicator,(((datepart(dw, dates) + 5)%7) + 1),1) = '1' 
				then 'Include' else 'Exlcude' end as flag
	from Day_Indicator) x
where flag='Include';
	