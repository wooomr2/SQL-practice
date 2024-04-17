select v.value velocity, l.value level, count(1) as count
from
    auto_repair l
    join auto_repair v on v.auto = l.auto
    and v.repair_date = l.repair_date
    and l.client = v.client
where
    l.indicator = 'level'
    and v.indicator = 'velocity'
group by
    v.value,
    l.value
order by v.value, l.value;

select distinct
    value
from auto_repair
where
    indicator = 'level'
order by value;

-- Solution using CROSSTAB in PostgreSQL
-- select * from crosstab('base query', 'list of columns') as result(final columns with data type)
select
    velocity,
    coalesce(good, 0) as good,
    coalesce(wrong, 0) as wrong,
    coalesce(regular, 0) as regular
from crosstab (
        'select v.value velocity, l.value level,count(1) as count
				from auto_repair l
				join auto_repair v on v.auto=l.auto and v.repair_date=l.repair_date and l.client=v.client
				where l.indicator=''level'' and v.indicator=''velocity''
				group by v.value,l.value
			  order by v.value,l.value', 'select distinct value from auto_repair where indicator=''level'' order by value'
    ) as result (
        velocity varchar, good bigint, regular bigint, wrong bigint
    );

-- Solution using PIVOT in Micrososft SQLServer
select *
from (
        select v.value velocity, l.value level, count(1) as count
        from
            auto_repair l
            join auto_repair v on v.auto = l.auto
            and v.repair_date = l.repair_date
            and l.client = v.client
        where
            l.indicator = 'level'
            and v.indicator = 'velocity'
        group by
            v.value, l.value
    ) bq pivot (
        count(level) for level in ([good], [wrong], [regular])
    ) pq;