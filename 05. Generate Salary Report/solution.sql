
-- Load data to emp_transaction table
insert into emp_transaction
select emp_id, emp_name, trns_type, 
	round(base_salary * (percentage/100), 2) as amount
from salary
cross join
(
	select income as trns_type, cast(percentage as decimal) as percentage 
	from income
	  union
  select deduction as trns_type, cast(percentage as decimal) as percentage 
  from deduction
) as t
order by trns_type, emp_id


-- SOLUTION PostgreSQL
-- postgresql은 pivot 기능 x
-- crosstab 기본 문법
-- select * from crosstab('base query', 'list of columns') as result(final columns with data type)
create extension tablefunc;

select employee
, basic, allowance, others
, (basic + allowance + others) as gross
, insurance, health, house 
, (insurance + health + house) as total_deductions
, (basic + allowance + others) - (insurance + health + house) as net_pay
from crosstab('select emp_name, trns_type, amount
			           from emp_transaction
			          order by emp_name, trns_type'
			  ,'select distinct trns_type from emp_transaction order by trns_type')
	as result(employee varchar, allowance numeric, basic numeric, health numeric
			 , house numeric, insurance numeric, others numeric)




-- SOLUTION Microsoft SQL Server (Similar works for Oracle too, just replace [] with "")
select Employee
, Basic, Allowance, Others
, (Basic + Allowance + Others) as Gross
, Insurance, Health, House
, (Insurance + Health + House) as Total_Deductions
, ((Basic + Allowance + Others) - (Insurance + Health + House)) as Net_Pay
from 
    (
        select t.emp_name as Employee, t.trns_type, t.amount
        from emp_transaction t
        
    ) b
pivot 
    (
        sum(amount)
        for trns_type in ([Allowance],[Basic],[Health],[House],[Insurance],[Others])
    ) p;