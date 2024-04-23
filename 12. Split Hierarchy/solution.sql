-- SOLUTION
with recursive
    cte as (
        select employee, manager, row_number() over (
                order by employee
            ) as x, 1 as depth
        from company
        where
            manager = (
                select employee
                from company
                where
                    manager is null
            )
        union all
        select d.employee, d.manager, x, depth + 1 as depth
        from cte c
            join company d on c.employee = d.manager
    )
select concat('Team ', x), string_agg(member, ', ') as member
from (
        select manager as member, x, depth
        from cte
        union
        select employee as member, x, depth
        from cte
        order by depth
    ) y
group by
    x
order by x;

-- OTHER SOLUTION
-- STEP1
select * from company;

-- STEP2
select mng.employee, concat(
        'Team ', row_number() over (
            order by mng.employee
        )
    ) as teams
from company root
    join company mng on root.employee = mng.manager
where
    root.manager is null;

-- STEP3
with recursive
    cte as (
        select c.employee, c.manager, t.teams
        from company as c
            cross join cte_teams as t
        where
            c.manager is null
    ),
    cte_teams as (
        select mng.employee, concat(
                'Team ', row_number() over (
                    order by mng.employee
                )
            ) as teams
        from company as root
            join company as mng on root.employee = mng.manager
        where
            root.manager is null
    )
select *
from cte;

-- STEP4
with recursive
    cte as (
        select c.employee, c.manager, t.teams
        from company c
            cross join cte_teams t
        where
            c.manager is null
        union
        select c.employee, c.manager, t.teams
        from
            company c
            join cte on cte.employee = c.manager
            left join cte_teams t on t.employee = c.employee
    ),
    cte_teams AS (
        select mng.employee, concat(
                'Team ', row_number() over (
                    order by mng.employee
                )
            ) as teams
        from company root
            join company as mng on root.employee = mng.manager
        where
            root.manager is null
    )
select *
from cte;

-- STEP5
with recursive
    cte as (
        select c.employee, c.manager, t.teams
        from company c
            cross join cte_teams t
        where
            c.manager is null
        union
        select c.employee, c.manager, coalesce(t.teams, cte.teams) as teams
            /*, case when t.teams is not null then t.teams 
            else case when c.manager = cte.employee then cte.teams end 
            end as teams*/
        from
            company c
            join cte on cte.employee = c.manager
            left join cte_teams t on t.employee = c.employee
    ),
    cte_teams AS (
        select mng.employee, concat(
                'Team ', row_number() over (
                    order by mng.employee
                )
            ) as teams
        from company root
            join company as mng on root.employee = mng.manager
        where
            root.manager is null
    )
select teams, string_agg(employee, ', ') as member
from cte
group by
    teams
order by teams;