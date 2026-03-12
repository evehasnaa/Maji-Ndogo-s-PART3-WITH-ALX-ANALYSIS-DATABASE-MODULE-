/* I think there are two reasons this can happen.
1. These workers are all humans and make mistakes so this is expected.
2. Unfortunately, the alternative is that someone assigned scores incorrectly on purpose!
*/

/* Ok, so thinking about this a bit. How would we go about finding out if any of our employees are corrupt?
Let's say all employees make mistakes, if someone is corrupt, they will be making a lot of "mistakes", more than average, for example. But someone
could just be clumsy, so we should try to get more evidence...

*/

with Incorrect_records as (
 select e.employee_name
-- e.assigned_employee_id
		,r.location_id as audit_location , 
		v.record_id
        ,r.true_water_source_score as  auditor_score
         , w.subjective_quality_score as  surveyor_score
from auditor_report as r
join visits v
on r.location_id= v.location_id 
join water_quality as w 
on v.record_id= w.record_id
join employee e 
on v.assigned_employee_id=e.assigned_employee_id
where w.subjective_quality_score !=  r.true_water_source_score 
and v.visit_count=1
),
-- This CTE calculates the number of mistakes each employee made mistake 
 count_Irror as (
select employee_name,
count(employee_name) as num_of_mistake 
from Incorrect_records
group by employee_name
), 

/*select * from Incorrect_records;
-- Let's first get a unique list of employees from this table.

select count( distinct employee_name )
from Incorrect_records;*/


-- 2. Now calculate the list of the number_of_mistakes in error_count.
avg_error_list  as(

select employee_name , 
 num_of_mistake
from count_irror
having num_of_mistake> ( select avg(num_of_mistake ) 
							from count_Irror)
                            )
select* 
from avg_error_list;



-- 2. Now calculate the average of the number_of_mistakes in error_count.
/* select  round(avg (num_of_mistake ),0) as avg_num_Mistake
from count_Irror;
*/


/* select round(avg (num_of_mistake ),0) as avg_num_Mistake
from count_Irror; */