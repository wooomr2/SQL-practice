with
    cte as (
        select *, round(
                avg(rating) over (
                    partition by
                        hotel
                    order by year range between unbounded preceding
                        and unbounded following
                ), 2
            ) as avg_rating
        from hotel_ratings
    ),
    cte_rnk as (
        select *, abs(avg_rating - rating), rank() over (
                partition by
                    hotel
                order by abs(avg_rating - rating) desc
            ) rnk
        from cte
    )
select hotel, year, rating
from cte_rnk
where
    rnk > 1
order by hotel, year;