-- lag(value any [, offset integer [, default any ]])
/*
returns value evaluated at the row that is offset rows before the current row within the partition;
if there is no such row, instead return default.
Both offset and default are evaluated with respect to the current row.
If omitted, offset defaults to 1 and default to null
*/

-- lead(value any [, offset integer [, default any ]])

-- Solution INCLUDING the first test marks
select *
from (select *, lag(marks,1,0) over(order by test_id) as prev_test_mark
	from student_tests) x
where x.marks > prev_test_mark;


-- Solution EXCLUDING the first test marks
select *
from (select *, lag(marks,1,marks) over(order by test_id) as prev_test_mark
	from student_tests) x
where x.marks > prev_test_mark;